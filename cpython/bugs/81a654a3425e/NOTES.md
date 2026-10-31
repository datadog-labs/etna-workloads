Parser with `exit_on_error=False` and a missing required positional.
Clean: `parse_args([])` raises `ArgumentError` (caught, message printed).
Buggy: the injection calls `self.error()` instead, which prints usage to stderr and exits with SystemExit(2), so the exception is never raised.
