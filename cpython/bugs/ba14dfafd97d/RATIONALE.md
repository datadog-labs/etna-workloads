# gh-123378: UnicodeError.__str__ crash

v3.15.2 still has the fix's bounds check in all three `__str__` functions in `Objects/exceptions.c`
(`UnicodeEncodeError_str`, `UnicodeDecodeError_str`, `UnicodeTranslateError_str`). Each has the line
`if ((start >= 0 && start < len) && (end >= 0 && end <= len) && end == start + 1)`.

Change: in all three functions that condition is reduced to the pre-fix `if (start < len && end == start + 1)`.
This reverses the fix's condition hunk in each of the three functions. The code is equivalent to
the old `uself->start < LEN && uself->end == uself->start+1`. The local `len`/`start`/`end` variables
and the later `check_unicode_error_attribute` call are unchanged and unrelated to this bug.

Effect: a negative `start` with `end == start+1` (e.g. start=-1, end=0) goes down the single-character
path. `PyUnicode_ReadChar` then fails with an exception set, which is then ignored. In the decode
case `PyBytes_AS_STRING(obj)[-1]` reads out of bounds. `end > len` is also no longer rejected.

Oracle: `test_unicode_error_str_does_not_crash` fails, and the run aborts with a crash. The other
failures in the output come from that crash cutting the run short.
