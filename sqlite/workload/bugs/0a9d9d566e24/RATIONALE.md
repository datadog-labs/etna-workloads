# Rationale

Fix hunk (src/expr.c, sqlite3CodeSubselect): removed `pSelect->selFlags &= ~SF_Distinct;`
for the `x IN (SELECT DISTINCT ...)` case.

In 3.54.1 the subselect is now compiled from a duplicate (`pCopy = sqlite3SelectDup(...)`)
in the same IN-operator branch of sqlite3CodeSubselect(). I re-added the stripping
there: `if( pCopy ) pCopy->selFlags &= ~SF_Distinct;` right after the dup. This is the
same behaviour as the old line (DISTINCT dropped before sqlite3Select() runs on the IN subquery).

Oracle cases failing (test/in5.test): in5-6.1.2 (collation mismatch: count wrong),
in5-6.2.2 (DISTINCT ... LIMIT 5 returns wrong count), in5-6.3.1 (DISTINCT ... LIMIT 2 wrong count).
