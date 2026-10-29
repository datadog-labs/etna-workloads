# Rationale

Fix: the xfer optimization must be skipped for INSERT ... SELECT ... RETURNING.
The fix added `pSelect!=0 && pTrigger==0` to the call site in sqlite3Insert()
and removed the `pSelect==0` and `sqlite3TriggerList()` checks from xferOptimization().

Changes in src/insert.c (reversing both hunks):
- sqlite3Insert(): dropped `pSelect!=0 && pTrigger==0` from the xfer condition
  (hunk 1). RETURNING is implemented as a trigger, so `pTrigger` is what
  excluded it.
- xferOptimization(): restored the `pSelect==0 -> return 0` check in place of
  `assert(pSelect!=0)`, and restored the in-function trigger check (hunk 2).
  In 3.54.1 sqlite3TriggerList() also returns the RETURNING trigger, so the
  restored check skips `bReturning` triggers to match the pre-fix behaviour,
  where ordinary triggers blocked xfer but RETURNING did not.

Oracle: returning1-16.0 (INSERT INTO t2 SELECT * FROM t1 RETURNING *) hits
`Assertion !pTrigger failed` in sqlite3Insert. Without asserts, the xfer path
would run and RETURNING rows would be lost. insert4-10.4 (xferopt count 0)
would fail likewise, but the run aborts at returning1-16.0.
