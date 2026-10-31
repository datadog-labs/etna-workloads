# gh-118216: dotted `__future__` imports

The fix added `level == 0` checks in three places. In v3.15.2 the compile.c check no longer exists; the logic now lives in symtable.c.

- `Python/future.c` `future_parse`: removed `&& s->v.ImportFrom.level == 0`. This reverses the future.c hunk. `from .__future__ import x` is treated as a real future statement again, so feature names are validated.
- `Python/symtable.c` `check_import_from`: removed `&& s->v.ImportFrom.level == 0`. This is the successor of the compile.c hunk (the "must occur at the beginning" check). A dotted `__future__` import is again flagged as a late future import.

Oracle failure: `FutureTest.test_future_dotted_import` fails. `exec("from .__future__ import spam")` raises `SyntaxError: future feature spam is not defined` instead of `ImportError`.
