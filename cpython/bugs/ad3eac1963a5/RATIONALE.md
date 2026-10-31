# Rationale

Reverts the `time.strftime()` hunk of the fix (Modules/timemodule.c) in v3.15.2.

`time_strftime()` once again converts the whole format string with
`PyUnicode_AsWideCharString()` (or `PyUnicode_EncodeLocale()` without
`HAVE_WCSFTIME`), takes its length with `wcslen`/`strlen`, and makes a single
`time_strftime1()` call. This replaces the fix's loop that split the format into
ASCII runs, which were passed to strftime, and non-ASCII runs and `\0`, which were copied verbatim.
`time_strftime1()` is the helper the fix introduced. It stays, because it holds the
buffer-growing logic that the old inline loop had.

Effects, matching the bug: an embedded NUL ends the format (the NUL is rejected with
`ValueError: embedded null character`), and non-encodable characters and surrogates
are exposed to the locale conversion.

The datetime hunks of the fix (`wrap_strftime`) are not reverted. `time.strftime`
is the only path that reproduces the bug here.

Failing oracle case: `test.test_time.TimeTestCase.test_strftime_special` fails with
`ValueError: embedded null character` on `time.strftime('\0', tt)`.
