# Rationale

Hunk reversed: the `wait_result_broken_or_wakeup` hunk of fix.patch. In
v3.15.2 the shutdown-lock is held in `submit()` around `wakeup()`, while
`clear()` is called unlocked by the manager thread. I restored the pre-fix
`with self.shutdown_lock:` around `self.thread_wakeup.clear()` in
`Lib/concurrent/futures/process.py`. The comment-only hunks were not reverted.

Effect: if `wakeup()` blocks on a full pipe while `submit()` holds
`_shutdown_lock`, the manager thread blocks on that lock in `clear()`.
Neither side can proceed, so this is the gh-105829 deadlock.

Oracle: `./check.sh` did not finish. It hung until the 10-minute background
limit and was killed, with no per-case output. I believe the hang is the
deadlock, most likely in `test_gh105829_should_not_deadlock_if_wakeup_pipe_full`
(it uses a SIGALRM timeout), but I did not confirm which case hung.
