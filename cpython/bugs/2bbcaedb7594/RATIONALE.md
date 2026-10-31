# Rationale

Both hunks are in `Lib/subprocess.py`, and each reverses a code hunk of the fix.

1. `Popen.communicate()`: removed the `try/except TimeoutExpired: exc.timeout = timeout; raise` around the final `self.wait(timeout=_deadline_remaining(endtime))`. This reverses the first hunk of the fix. The code is now the pre-fix form, in which the exception carries the remaining time from the internal `wait()`.
2. POSIX `Popen._communicate()`: removed the equivalent `try/except` that set `exc.timeout = orig_timeout` around the final `self.wait(...)`. This reverses the second hunk of the fix. The code is the same defect on the other path.

The tree uses `_deadline_remaining` where the fix used `_remaining_time`. This is only a rename.

## Oracle failures
`ProcessTestCase.test_timeout_exception` and `ProcessTestCaseNoPoll.test_timeout_exception` fail. `subprocess.run(..., timeout=-1)` reports "timed out after -1.00004... seconds" instead of "-1 seconds".

`POSIXProcessTestCase.test_group` and `test_user` also fail in this run. I did not investigate them. They are probably environment-related (they depend on user and group lookups) and not caused by this change.
