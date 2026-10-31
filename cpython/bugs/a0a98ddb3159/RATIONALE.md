# Rationale

Single hunk, in `releasebuffer_call_python()` (Objects/typeobject.c), reversing the one hunk in fix.patch:
- Removed `PyErr_GetRaisedException()` at entry and `PyErr_SetRaisedException(exc)` / `assert(!PyErr_Occurred())` at exit (the `end:` label).
- The three `goto end;` became `return;` again, as before the fix.

The function still has the same shape in v3.15.2 (only `PyErr_WriteUnraisable` became `PyErr_FormatUnraisable`), so this restores the pre-fix code. `__release_buffer__` is again called with an exception active, e.g. when `bytearray.extend` fails with BufferError.

## Oracle failures
check.sh reports 4 of 95 cases failing, and the run crashed (assert or abort) partway through:
test_release_buffer_with_exception_set (the fix's new test), test_release_saves_reference, test_release_saves_reference_no_subclassing and test_same_buffer_returned. The last three are probably casualties of the crash.
