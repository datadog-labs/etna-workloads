Trigger `AFTER DELETE` whose body is `SELECT RAISE(ABORT, '...')`, then a DELETE that fires it.
The injection lets constant factoring happen inside trigger sub-programs (okConstFactor set for nested parses).
Clean shell: `Error near line 6: delete is not supported`, exit 1.
Buggy shell: assertion failure in sqlite3VdbeMemStringify, aborts (exit -6).
(Derived from triggerC-1.9.)
