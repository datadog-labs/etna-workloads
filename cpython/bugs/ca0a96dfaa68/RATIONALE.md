# Rationale

Changed `Grammar/python.gram` (`except_block`, `except_star_block`) and regenerated `Parser/parser.c` with pegen.

- Reverses the fix's grammar hunks: removes the plain `'except' expression ':'` / `'except' expression 'as' NAME ':'` alternatives (and the `except*` equivalents) that were tried before the `expressions` alternative. Unparenthesised `except A:` now goes through the `expressions` rule guarded by `CHECK_VERSION(14, ...)`, so with `feature_version < 14` even a single-expression handler is rejected. The error message text is also restored to the pre-fix "except expressions without parentheses" wording.
- The fix's `parser.c` hunk is the regenerated output of the same grammar change.

Oracle failures: 6 errors in `test_ast.test_ast`, including `test_pep758_except_with_single_expr`. `ast.parse(..., feature_version=(3, 13))` raises `SyntaxError: except expressions without parentheses only supported in Python 3.14 and greater` for a plain `except ValueError:`.
