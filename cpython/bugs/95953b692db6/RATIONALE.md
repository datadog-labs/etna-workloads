# gh-140471 reintroduced

Fix: AST node init formatted field names from a user-controlled `_fields` with `%U`
(which requires `str`) instead of `%R`. A non-str name (e.g. bytes) overflowed/crashed.

In v3.15.2 the warnings were turned into `TypeError`s. One site still has the fix's
`%R` form: the "Field ... is missing from ..._field_types" error in `ast_type_init`.

## Changes (same edit in both, so the generated file stays consistent)
- `Parser/asdl_c.py` and `Python/Python-ast.c` (`ast_type_init`): message
  `"Field %R is missing from %T._field_types"` -> `"Field '%U' is missing from %T._field_types"`.
  This reverses fix hunk 1 (asdl_c.py / Python-ast.c "Field %R is missing ...").
  Same defect: `%U` applied to an unchecked `_fields` entry.
- The fix's second hunk ("missing 1 required positional argument: %R") has no
  direct equivalent. `format_missing` already uses `'%U'`, so I left it unchanged.

## Oracle
`test_malformed_fields_with_bytes` (`_fields = (b'\xff'*64,)`, `_field_types = {'a': int}`)
reaches the changed `%U` with a bytes object. The test run crashes (assert/fatal error)
and the remaining test_ast cases are not run, so 209 of 218 are reported failing.
