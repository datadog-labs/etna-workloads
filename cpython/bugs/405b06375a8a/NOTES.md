Reproducer for the injected bug: `_ExecutorManagerThread.wait_result_broken_or_wakeup` calls
`thread_wakeup.clear()` while holding `shutdown_lock`. `submit()` calls `thread_wakeup.wakeup()`
while also holding `shutdown_lock`, and wakeup can block (gh-105829).

repro.py mocks the wakeup object (as the upstream test does) so wakeup() blocks until clear()
runs, and delays the manager thread start. Clean: prints `[0, 1, ..., 9]`. Buggy: deadlock
(submit blocks in wakeup holding the lock, manager blocks on the lock in clear());
faulthandler dumps tracebacks after 20s and exits with status 1.
