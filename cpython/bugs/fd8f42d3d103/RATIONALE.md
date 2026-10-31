# gh-135427 reintroduced

Fix: `warn_about_fork_with_threads` returns int and propagates errors from
`PyErr_WarnFormat` so `os.fork/fork1/forkpty` fail under `-Werror`.

Change (Modules/posixmodule.c, `warn_about_fork_with_threads`): the
`PyErr_WarnFormat(...)` result is no longer returned and `PyErr_Clear()` is
restored after it (reverses the `return PyErr_WarnFormat` / removed
`PyErr_Clear()` hunk). The function still returns int (v3.15.2 callers check
`< 0`), but it can now never be negative, so the callers' error checks
(reverse of the os_fork1/os_fork/os_forkpty hunks) are dead and the warning
error is silently swallowed.

Expected oracle failures: ForkInThreads.test_fork / test_forkpty (which expect
the DeprecationWarning to be raised as an error under -W error).
