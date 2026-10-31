# Rationale

Changed `Python/ceval.c`, `_PyEval_ExceptionGroupMatch`: removed the block that
creates a frame object, builds a traceback with `_PyTraceBack_FromFrame(NULL, f)`
and sets it on the wrapper ExceptionGroup when a naked exception is wrapped.
This reverses the fix's `ceval.c` hunk that added that block (gh-128799). The
`frame` parameter and callers are left in place (unused), so the build is unchanged elsewhere.
The wrapper then has no traceback, so the `except*` frame is missing from it, as before the fix.

Failing oracle cases: `test_exception_group_wrapped_naked` (Py and C
variants): the report lacks the `in exc` / `except* Exception as e:` frame lines
for the wrapping group. Other errors in the run were not examined; I did not compare them against an unmodified build.
