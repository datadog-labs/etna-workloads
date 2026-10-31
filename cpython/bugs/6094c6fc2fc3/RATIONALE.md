# Rationale

Fix hunk reversed: `Lib/logging/handlers.py`, `RotatingFileHandler.shouldRollover`,
the added `if not pos: return False` ("gh-116263: Never rollover an empty file").

In v3.15.2 the `pos = self.stream.tell()` / `pos + len(msg)` part is already in
the post-fix form (and wrapped in a try for gh-143237), so reversing the hunk
verbatim does not apply. I removed only the empty-file early return. Without it, an
empty log file is rolled over whenever a single record is at least `maxBytes`,
which is the pre-fix behaviour. I did not restore `seek(0, 2)`, since it would
raise on named pipes outside the try block and is not needed to bring the bug back.

Oracle cases that fail: `RotatingFileHandlerTest.test_max_bytes`,
`test_max_bytes_delay` (`shouldRollover(large)` is True on an empty file),
`test_rollover_filenames` (the `.1` file exists after the first emit), and
`test_should_not_rollover`. These are the cases the fix added or changed.
