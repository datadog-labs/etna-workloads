Reproducer: with the "spawn" start method, a child process receives a Queue (and its SemLock),
then starts a nested child and passes the same Queue on.

Clean: the nested process works; prints exit codes 0 and `[1, 2]`.
Buggy: `SemLock.__setstate__` no longer sets `_is_fork_ctx`, so re-pickling the Queue in the child
raises `AttributeError: 'Lock' object has no attribute 'is_fork_ctx'`. The outer child exits 1 and
`q.get` raises `Empty`.
