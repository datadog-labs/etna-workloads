# Rationale

Fix hunks (src/insert.c):
1. Caller in sqlite3Insert no longer tests `pParse->pWith`; moved into xferOptimization.
2. xferOptimization gained `if( pParse->pWith || pSelect->pWith ) return 0;`.

In 3.54.1 only the combined check (hunk 2's form) exists inside xferOptimization (src/insert.c, ~line 3093).
Reintroduced the pre-fix behaviour: the check only looks at `pParse->pWith`, dropping `pSelect->pWith`.
Pre-fix the effective condition was exactly `pParse->pWith==0`, so a WITH clause attached to the SELECT
(`INSERT INTO t1 WITH x AS (...) SELECT * FROM x`) no longer disables the xfer optimization, giving a spurious "no such table: x".

Failing oracle cases: with2-5.7, with2-5.8 (xfer optimization used, wrong count / no such table), plus with2-7.1..7.5.
