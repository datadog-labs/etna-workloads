repro.py calls `PyUnicodeWriter.write_substring("abc", 1, 1)` (empty substring, end != 0) on a fresh writer, then `finish()`.
Clean: prints `''`. Buggy: the early `end == 0` check replaced the `len == 0` check, so the empty slice reaches `_PyUnicodeWriter_Prepare`/copy and aborts with a debug assertion (`buffer != NULL`, SIGABRT).
