# Rationale

Fix hunk reversed: `Lib/asyncio/subprocess.py`, `Process.communicate()`:
`if self.stdin is not None:` -> `if input is not None:`.

With this, `communicate(None)` skips `_feed_stdin()` and never closes the child's
stdin (pre-fix behaviour). In v3.15.2 `_feed_stdin` already tolerates
`input=None` (the `input is not None` guard was folded into its try block), so
the `communicate()` condition is the only line that restores the bug. The
`_feed_stdin` guard is harmless and left as is.

Oracle: `test_communicate_none_input` (all watcher variants) runs `cat` with a
stdin pipe and calls `communicate()`. stdin is never closed, so `cat` never sees
EOF and the call hangs until the test's `wait_for(LONG_TIMEOUT)` fires with
TimeoutError. Because of those long timeouts, `./check.sh` ran past 10 minutes
here and was killed. I did not see its final output, so I have not confirmed the
failure by running it.
