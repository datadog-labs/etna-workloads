`repro.py` calls `codecs.unicode_escape_decode` on inputs with invalid escapes after a truncated `\x` escape. The error handler is `ignore` or a handler that mutates `exc.object`. It prints the result and the DeprecationWarning messages.

The clean interpreter reports the right escape (`"\z"`, `"\501"`). The buggy one reports garbage (`"\Ý"`) because it reads the escape through a pointer into the original data, which was replaced when the handler ran. That is a use-after-free (stale pointer). The decoded values are the same on both.
