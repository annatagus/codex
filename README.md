# Codex

A documentation system for Common Lisp.

# Overview

# Usage

## Tags

### `clref`

**TeX Syntax:** `\clref{<package>:<symbol>}`

Reference a symbol by name. The name must have the full package name.

The package name determines what kind of link will be generated:

* If the symbol is part of the Common Lisp package, a link to the
  [Common Lisp HyperSpec][clhs] will be generated.
* If the symbol comes from a package that's part of the project, a link to the
  symbol in the proper document will be generated.
* If the symbol belongs to an external package, a link to the [Quickdocs][qd]
  page will be generated.

**Examples:**

```tex
... we use the \clref{cl:find} function in \clref{myapp:my-function} to find ...
```

# Implementation

Codex uses [Quickdocs's][qd] [parser][qd-parser] system to extract
documentation from systems.

Each package is a separate document.

[clhs]: http://www.lispworks.com/documentation/HyperSpec/Front/
[qd]: http://quickdocs.org/
[qd-parser]: https://github.com/fukamachi/quickdocs/blob/master/quickdocs-parser.asd

# License

Copyright (c) 2014 Fernando Borretti

Licensed under the MIT License.
