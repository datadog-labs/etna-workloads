Hunk: Python/compile.c load_args_for_super (now Python/codegen.c). The fix changed the location
passed to the `super` global load from `loc` (whole `super()` call) to `LOC(e->v.Call.func)`.
Reverted in codegen.c: codegen_nameop(c, loc, super_name, Load).
Oracle: test_compile.TestSourcePositions.test_load_super_attr fails (LOAD_GLOBAL end_column 11 instead of 9).
