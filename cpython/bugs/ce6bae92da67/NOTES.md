Patches `TracebackException.format` to return a line without a trailing newline, then calls
`_interpreters.capture_exception`. Clean prints `'ValueError: ' 'x-no-nl'`; buggy aborts on the
debug assertion `formatted[size-1] == '\n'` in `_format_TracebackException` (exit -6).
