# Rationale

In v3.15.2 the fix's logic lives in the helper `_make_input_view()` in `Lib/subprocess.py`
(used by `_communicate` and `_communicate_io_posix`). The fix cast a memoryview input to a
byte view (`input_view = self._input.cast("b")`) so `len(input_view)` is a byte count.

Change: removed the `isinstance(input_data, memoryview)` branch with the `.cast("b")`, so a
memoryview is again wrapped as-is with `memoryview(input_data)`. This reverses the fix's first
hunk (the cast). The second hunk (progress check against `len(input_view)`) is already in place
in `_communicate_io_posix`; with a non-byte view that length is an element count again, which is
the original defect.

Failing oracle cases: `test_communicate_memoryview_input_nonbyte` (ProcessTestCase and
ProcessTestCaseNoPoll). Stdout is truncated to 16384 bytes instead of 16388 (len(stdout)=16384
vs len(expected_bytes)=16388). `test_group` and `test_user` also fail, apparently for environment reasons.
