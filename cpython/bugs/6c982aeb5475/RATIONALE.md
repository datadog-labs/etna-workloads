# Rationale

Fix hunk reversed: `Lib/traceback.py`, `print_last()`. The fix changed the
`print_exception(...)` calls from positional `limit, file, chain` to keywords.

In v3.15.2 `print_exception(exc, /, value=_sentinel, tb=_sentinel, limit=None,
file=None, chain=True)`, so positional `limit, file, chain` bind to
`value, tb, limit`. I restored the positional calls in both branches
(`sys.last_exc` and the `last_type/last_value/last_traceback` fallback).
The docstring and docs hunks are not code and were left alone.

Oracle failures: `test_print_last` (the fix's test) fails, since `file` ends
up as `tb` and `print_exception` raises. In the run, 41 tests in
test_traceback errored with `'_io.StringIO' object has no attribute 'tb_frame'`.
