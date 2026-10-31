ast.parse() on source with `return` in a `finally` block must not emit the PEP 765 SyntaxWarning (it only belongs at compile time).
Clean prints `[]`; buggy (injection passes syntax-check flag 1 to _PyAST_Preprocess) prints `['...return' in a 'finally' block']`.
