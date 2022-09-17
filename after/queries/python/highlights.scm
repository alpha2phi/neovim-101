; Sources:
; - the python/highlights.scm: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/python/highlights.scm
; - the playground: https://tree-sitter.github.io/tree-sitter/playground
; - tutorial: https://siraben.dev/2022/03/01/tree-sitter.html

; Inspiration:
; - https://gist.github.com/andrusha/952550

; Operators
;
(("not" @keyword.operator) (set! conceal "¬"))
("or" @keyword.operator (set! conceal "∨"))
("and" @keyword.operator (set! conceal "∧"))
("in" @keyword.operator (set! conceal "∈"))
; ("not" @keyword.operator (#eq? @keyword.operator "in") (set! conceal "∉"))
; ("not" @keyword.operator (#eq? @keyword.operator "in") (set! conceal "∉"))

("==" @operator (set! conceal "≡"))
("!=" @operator (set! conceal "≢"))
("<=" @operator (set! conceal "≤"))
(">=" @operator (set! conceal "≥"))
("*" @operator (set! conceal "∙"))
; ("/" @operator (set! conceal "÷"))

; Functions
;
; used in function call contexts, e.g. `sum(...)` -> `∑(...)`
;
((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "sum")
 (set! conceal "∑"))

((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "all")
 (set! conceal "∀"))

((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "any")
 (set! conceal "∃"))

((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "len")
 (set! conceal "#"))

((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "int")
 (set! conceal "ℤ"))

((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "float")
 (set! conceal "ℝ"))

((call function: (attribute) @method)
 (#eq? @method "math\.sqrt")
 (set! conceal "√"))

("lambda" @keyword.function (set! conceal "λ"))

; Important builtins
;
(((attribute) @constant)
 (#eq? @constant "math\.pi")
 (set! conceal "π"))

((none) @constant.builtin (set! conceal "∅"))

; Main types
;
((type (identifier) @type) (#eq? @type "int") (set! conceal "ℤ"))
((type (identifier) @type) (#eq? @type "float") (set! conceal "ℝ"))
