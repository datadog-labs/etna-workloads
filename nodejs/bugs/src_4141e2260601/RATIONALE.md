# Re-introduced bug: kill() on a never-spawned child signals own process group

**Bug.** libuv only sets `process->pid` when `uv_spawn()` succeeds. For a child that failed to
spawn (e.g. ENOENT) the pid is 0, but `ChildProcess.kill()` still called `uv_process_kill()`,
which calls `kill(0, sig)` and signals every process in the caller's own process group
(including Node itself).

**Change (src/process_wrap.cc, one hunk).** In `ProcessWrap::Kill`, removed the
`process_.pid > 0 ? ... : UV_ESRCH` guard and went back to the unconditional
`int err = uv_process_kill(&wrap->process_, signal);`. This corresponds to the fix's second
hunk (the Kill guard).

**Not reverted:** the fix's constructor hunk (`process_.pid = 0;`) is deliberately kept. A full
reversal does not reproduce the bug: without the zeroing, `process_.pid` is uninitialised heap
memory, which in this debug build is non-zero garbage, so `kill(garbage)` returns ESRCH and
the test passes by luck. With pid zeroed and no guard, the failed-spawn handle deterministically
reaches `kill(0, SIGTERM)`.

**Failing test.** `parallel/test-child-process-kill-spawn-error` (failed on 2 consecutive runs):
```
not ok 1 parallel/test-child-process-kill-spawn-error
AssertionError [ERR_ASSERTION]: Expected values to be strictly equal:
'SIGTERM' !== null
```
The detached helper process kills its own process group with SIGTERM.
