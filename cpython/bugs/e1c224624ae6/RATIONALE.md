# gh-145783 reintroduced

## Changes
1. `Parser/parser.c` (all 539 generated action sites): `if ((_res == NULL || p->error_indicator) && PyErr_Occurred())` is reverted to `if (_res == NULL && PyErr_Occurred())`. This reverses every parser.c hunk of the fix, which are the output of the `c_generator.py` change. `Tools/` is outside the allowed paths, so the generator was left alone. A non-NULL action result is no longer discarded when `NEW_TYPE_COMMENT` (or another helper) set `error_indicator`.
2. `Parser/pegen.c`, `_PyPegen_run_parser`: removed the guard `if (res != NULL && PyErr_Occurred()) return NULL;`. This is a second, later safety net that catches the same defect from another path. Reverting only (1) leaves the oracle passing because this guard hides it. With it gone, the parser returns a successful AST while an exception is pending.

## Oracle failures
`test_non_utf8_type_comment_with_ignore_cookie` (the fix's new test) and other type-comment tests (nonasciidef, redundantdef, vardecl, withstmt, ...) fail. The run crashes: it ends incomplete with an assert or crash because a result is returned with an exception set.
