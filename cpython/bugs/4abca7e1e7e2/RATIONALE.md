# Rationale

Fix hunk: `Lib/subprocess.py` added, in `Popen.__init__`, `if stdout is STDOUT: raise ValueError("STDOUT can only be used for stderr")`.

Reversed by deleting that same check (same location, right after the `bufsize` type check) in v3.15.2's `Lib/subprocess.py`. The code is otherwise unchanged, so `stdout=subprocess.STDOUT` again flows into `_get_handles` and fails with a confusing low-level error (e.g. `OSError: [Errno 9] Bad file descriptor`) instead of a clear ValueError.

Oracle: `test_stdout_stdout` (and related tests) now fail; check.sh reports 9 errors in test_subprocess, with the Bad file descriptor OSError instead of ValueError.
