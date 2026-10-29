repro.sql: table t with a plain index i2(a,b) and a partial index i1(a,b) WHERE b=1 (i1 is listed first),
one row that does not satisfy the partial WHERE, then PRAGMA integrity_check.
The injection stops sqlite3GenerateIndexKey from discarding the cached "prior index" registers when the
prior index is partial. When the row is skipped by the partial index, i2 reuses registers that were never loaded.
Clean: prints ok / 0 / ok, exit 0. Buggy: assertion failure `memIsValid(&aMem[pOp->p3])` in sqlite3VdbeExec (abort, status -6).
