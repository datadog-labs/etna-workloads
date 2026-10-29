# Rationale

Fix hunk reversed: `where.c` `sqlite3WhereBegin` – the `WHERE_AGG_DISTINCT` check that keeps the
omit-noop-join optimization off for `SELECT agg(DISTINCT ...)`. In 3.54.1 this lives in the call
to `whereOmitNoopJoin()`; I removed `WHERE_AGG_DISTINCT` from that condition (keeping
`WHERE_KEEP_ALL_JOINS`) and removed the matching assert inside `whereOmitNoopJoin()`.
Pre-fix, `pResultSet!=0` alone gated the optimization, and for aggregate-DISTINCT queries
pResultSet is the DISTINCT arg list, so a LEFT JOIN table whose column is the aggregate argument
could be omitted. The flag definition and select.c hunks are left in place (unused flag is harmless).

Oracle failures (test/distinctagg.test): 5.3.1, 5.6.1, 5.7.1 return 0 instead of 1, and 5.7.2 hits
the assertion `pC!=0` in sqlite3VdbeExec (crash from the omitted table's cursor).
