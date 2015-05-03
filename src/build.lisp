(in-package :cl-user)
(defpackage codex.build
  (:use :cl)
  (:export :build-document
           :build-manifest)
  (:documentation "Build manifests and documents."))
(in-package :codex.build)

(defun load-document (document directory)
  "Load a CommonDoc document from the sources of a Codex document."
  ;; Take all the document sources, concatenate them all, and parse them.
  (let* ((doc-source-files (loop for namestring in (codex.manifest:document-sources document)
                             collecting
                             (merge-pathnames (parse-namestring namestring)
                                              directory)))
         (sections (codex.markup:with-markup ((codex.manifest:document-markup-format document))
                     (loop for file in doc-source-files collecting
                       (codex.markup:parse-string (uiop:read-file-string file))))))
    (make-instance 'common-doc:document
                   :title (codex.manifest:document-title document)
                   :children sections)))

(defun build-document (document directory)
  "Build a document."
  (let* ((doc (load-document document directory))
         (build-directory (merge-pathnames #p"build/html/"
                                           directory))
         (output-format (codex.manifest:document-output-format document))
         (html-template (codex.tmpl:find-template (codex.manifest:output-html-template output-format))))
    ;; Expand macros
    (let ((doc (common-doc.macro:expand-macros doc)))
      (setf doc (common-doc.ops:fill-unique-refs doc))
      ;; Now we have a document, lets emit the HTML
      (if html-template
          (common-html.template:with-template (html-template :directory build-directory)
            (common-html.multi-emit:multi-emit doc
                                               build-directory
                                               :max-depth 1))
          (error 'codex.error:template-error
                 :template-name html-template
                 :message "No such template known."))
      doc)))

(defun build-manifest (manifest directory)
  "Build a manifest."
  ;; First, load all the systems, extracting documentation information into the
  ;; global index
  (let ((codex.macro:*index* (docparser:parse (codex.manifest:manifest-systems manifest))))
    ;; Set the current markup format
    (codex.markup:with-markup ((codex.manifest:manifest-markup-format manifest))
      ;; Go through each document, building it
      (loop for document in (codex.manifest:manifest-documents manifest) do
        (build-document document directory)))))
