# Rationale

Fix gh-133194 added `CHECK_VERSION(..., 14, "except expressions without parentheses", ...)` to the PEP 758 `except A, B:` and `except* A, B:` alternatives. v3.15.2 still has these checks (message text differs slightly), but the fix's hunks no longer reverse cleanly. I removed them:

- `Grammar/python.gram`, `except_block` alternative `'except' e=expressions ':' b=block`: now plain `_PyAST_ExceptHandler(e, NULL, b, EXTRA)`. This reverses the first grammar hunk.
- `Grammar/python.gram`, `except_star_block` alternative `'except' '*' e=expressions ':' b=block`: same change. This reverses the second grammar hunk.
- `Parser/parser.c`: the two matching generated lines in `except_block_rule` and `except_star_block_rule`, edited by hand to match the grammar. This reverses the two parser.c hunks.

Oracle failures (from `./check.sh`): `test_pep758_except_without_parens` and `test_pep758_except_star_without_parens` in `test_ast.test_ast.AST_Tests` fail with "SyntaxError not raised" when `feature_version=(3, 13)` is passed.
