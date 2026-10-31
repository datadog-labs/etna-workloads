# Rationale (gh-144169)

Changed `Parser/asdl_c.py` (generator) and `Python/Python-ast.c` (generated, kept in sync) in `ast_type_init`:
- `"%T got multiple values for argument %R"` -> `'%U'` (reverses fix hunk 1).
- `"%T.__init__ got an unexpected keyword argument %R"` -> `'%U'` (reverses fix hunk 2).

`%U` requires a str; with non-str keys (e.g. `object()` or a str-equal fake) the formatting crashes/asserts.
The third fix hunk (`__replace__` message in `ast_type_replace_check`) is not present in v3.15.2:
`ast_type_replace` now delegates to the constructor via `PyObject_Call`, so that case goes through the reverted init code.

Oracle: `ASTConstructorTests.test_non_str_kwarg` fails, and the run crashes (abort/assert from `%U` on a non-str), so many later test_ast cases are reported failing.
