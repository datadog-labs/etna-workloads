# Rationale

Fix: AS names in the result set only resolve WHERE identifiers when nothing else matches (NC_AsMaybe), while in ORDER BY an AS name takes priority over any column name (`cnt==0` check dropped for ORDER BY).

In 3.54.1 the WHERE half is the unconditional `cnt==0` check in lookupName (unchanged). The ORDER BY priority is implemented in `resolveOrderGroupBy()` (src/resolve.c) by the `resolveAsName()` shortcut for bare/COLLATE-wrapped names. I removed that shortcut block (the only change). ORDER BY terms then resolve via `sqlite3ResolveExprNames()`, where AS names are only candidates when no column matches, i.e. the pre-fix behavior (same as the fix's removed `cnt==0 &&` gating for ORDER BY).

Failing oracle cases: resolver01-1.1, 1.3, 2.1, 2.3, 4.1 (e.g. `SELECT 1 AS y FROM t1,t2 ORDER BY y` now errors "ambiguous column name: y") and tkt2822-5.1..5.4 (ORDER BY alias vs same-named column picks the column).
