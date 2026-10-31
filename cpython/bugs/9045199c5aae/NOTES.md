Reproducer for bpo-33833: builds a `_ProactorSocketTransport` on a mocked proactor whose `send` returns an already-completed future, calls `write()` and then `_force_close()`, and runs the loop briefly. It prints the exceptions reported to the loop's exception handler.

Clean: `[]`. Buggy: `['AssertionError()']`, because `_loop_writing` asserts `f is self._write_fut` after `_force_close` has set `_write_fut` to None.
