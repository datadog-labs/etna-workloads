# Rationale

The fix added, to `ast_type_replace_check` (Python/Python-ast.c, generated from
Parser/asdl_c.py), a step discarding optional fields (`_field_types` entry is a
Union) from the `expecting` set, so omitted optional fields were not reported
as missing. In v3.15.2 `ast_type_replace_check` no longer exists: `__replace__`
just calls the constructor, which supplies defaults. So the hunk can't be
reversed literally.

Changes (Parser/asdl_c.py and the regenerated-equivalent Python/Python-ast.c, edited identically):
- New helper `ast_type_replace_check_missing`, called in `ast_type_replace`
  before `PyObject_Call`. It reinstates the pre-fix behaviour for exactly the
  case the fix's discard loop covered: optional fields (Union `_field_types`)
  absent from the instance dict and from kwargs raise TypeError instead of
  defaulting to None. Required fields are left to the constructor's own error.

Oracle: `CopyTests.test_replace_accept_missing_field_with_default` fails
(`copy.replace(ast.FunctionDef(name="foo", args=ast.arguments()), name="bar")`
raises TypeError for `returns`). All other oracle cases still pass.
