# Rationale

Fix hunk (Lib/subprocess.py, `_communicate`): added `except ValueError:` after
`self.stdin.flush()`, ignoring the error if `stdin.closed`.

In v3.15.2 the flush was refactored into the helper `_flush_stdin()` (Lib/subprocess.py),
called from `_communicate`. I removed the `except ValueError` clause (and fixed the
docstring) from that helper, restoring the pre-fix behaviour: a stdin closed before
`communicate()` makes `stdin.flush()` raise `ValueError: I/O operation on closed file`.

Oracle: `test_communicate_stdin_closed_before_call` (and other communicate tests that close stdin first) fail with that ValueError (10 errors in test_subprocess).
