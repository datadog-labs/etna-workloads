# Rationale

Change (Objects/exceptions.c, `unicode_error_adjust_start`): in the
`start >= objlen` branch, `start = objlen == 0 ? 0 : objlen - 1;` became
`start = objlen - 1;`.

This reverses the fix hunk that introduced `unicode_error_adjust_start`
(replacing the old inline `if (*start>=size) *start = size-1;`, which was
unguarded for size == 0). The fix's documented contract is to clip start to
`[0, max(0, objlen - 1)]`. The pre-fix code produced -1 for an empty object.
In v3.15.2 all getters (Encode/Decode/Translate GetStart and
`_PyUnicodeError_GetParams`) go through this single helper, so one
line restores the bug for every caller.

## Oracle failures
The `PyUnicode*Error_GetStart` tests on empty objects get -1 instead of 0.
In a debug build `assert_adjusted_unicode_error_start` (start >= 0) aborts,
so the test run crashes: 33 of 34 oracle cases in
test_capi/test_exceptions.py are reported failing (incomplete run), including
the get_start tests for decode/encode/translate errors.
