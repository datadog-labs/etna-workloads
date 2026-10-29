Reproducer: repro.sh builds a WITHOUT ROWID table whose PK/column collation is
rewritten (writable_schema) to an unregistered name "mysort", then reopens the
db and runs a SELECT followed by CREATE UNIQUE INDEX i1 ON t1(1).
Clean: both statements report "no such collation sequence: mysort", exit 1.
Buggy: CREATE INDEX hits SQLITE_ERROR_RETRY and aborts on an assert in
sqlite3LockAndPrepare (exit 134).
