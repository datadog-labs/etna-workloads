# Rationale

Code moved: `Lib/ast.py` `_write_fstring_inner` is now `_write_ftstring_inner` in `Lib/_ast_unparse.py`.

## Hunk changed
`Lib/_ast_unparse.py`, `_write_ftstring_inner`: removed the three lines that escape `\`, `'` and `"` in a format_spec constant.
This reverses the fix hunk that added those `value.replace(...)` calls. Only the `\n` escape remains, which is what the pre-fix code (`escape_newlines`) did.
The `is_format_spec` rename and the caller hunk are cosmetic and were left as they are.

## Oracle failures
- `CosmeticTestCase.test_backslash_in_format_spec`
- `CosmeticTestCase.test_quote_in_format_spec`

For example, `f"{x:\\ }"` unparses with the backslash unescaped, so the roundtrip yields a different AST. A quote in a format_spec is likewise not escaped.
`./check.sh` also reports 4 other `test_unparse` failures that are not oracle cases. I did not investigate them, so I can't confirm they predate this change.
