The reproducer calls the C API `PyUnicodeEncodeError_GetStart` (via `_testcapi.unicode_encode_get_start`) on a `UnicodeEncodeError` built with an empty string and start=0.

Clean: prints `0`. Buggy: the start clamp gives `objlen - 1 == -1` for an empty object, which trips the debug assertion `start >= min_start` in `assert_adjusted_unicode_error_start`, so the process aborts (exit -6).
