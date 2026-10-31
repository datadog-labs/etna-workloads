# Rationale

v3.15.2 has none of the fix's code (`_pipes_connected`, the exit-waiter wakeup in `_try_finish`), yet the oracle passes. The cause is a later, separate defence in `_connect_pipes`' `except BaseException` handler (`Lib/asyncio/base_subprocess.py`). That handler closes the already-connected pipes and the raw `proc.stdin/stdout/stderr`, so a cancelled `connect_*_pipe` no longer leaves the transport half-connected.

This is the same defect as the one the fix addresses. A cancellation during `_connect_pipes` leaves the transport in a broken state: not all pipes connected, and no `_try_finish` cleanup. The fix handled that state by waking exit waiters, and the later code covers it by cleaning up the pipes.

## Change
`Lib/asyncio/base_subprocess.py`: removed the pipe/raw-pipe closing loops from the `except BaseException` handler in `_connect_pipes`. The handler now only does `waiter.set_exception(exc)`, which is the pre-fix behaviour. This is the "fixed twice" case in the task: the other covering path was reverted instead of the fix's own hunks, since those hunks were never present.

## Oracle failures
`test_subprocess_read_pipe_cancelled`, `test_subprocess_write_pipe_cancelled` and `test_subprocess_read_write_pipe_cancelled`. All three fail in both `SubprocessPidfdWatcherTests` and `SubprocessThreadedWatcherTests`, 6 cases in total. With a cancelled pipe connection, the transport is left in the broken state described above.
