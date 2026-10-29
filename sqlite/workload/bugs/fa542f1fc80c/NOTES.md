Uses four shared-cache in-memory connections (`.connection`). Conn 2 holds a read lock on t1 inside BEGIN; conn 1's INSERT fails with "table is locked" and sets BtShared.isPending. Conn 3 then runs BEGIN; ROLLBACK, which has no btree transaction.
Clean: the rollback leaves isPending set, so conn 3's SELECT fails with "database table is locked".
Buggy: the rollback clears the lock state and isPending too early, so the SELECT succeeds (no error, no output).
