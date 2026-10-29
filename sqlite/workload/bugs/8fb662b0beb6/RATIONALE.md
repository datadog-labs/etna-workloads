# Rationale

Fix hunk reversed: `fts3DoOptimize` in `ext/fts3/fts3_write.c`. The fix made
'optimize' iterate over every language id in %_segdir (SQL_SELECT_ALL_LANGID).
Before the fix it merged only language 0 (`fts3SegmentMerge(p, 0, i, ...)`
for each index).

In 3.54.1 the function is restored to that form: the SQL_SELECT_ALL_LANGID loop
is removed and replaced by a single loop over `i<p->nIndex` with langid 0. The
`sqlite3Fts3PendingTermsFlush` call (a later addition) is kept.
`fts3SegmentMaxLevel` already takes iLangid in 3.54.1. That hunk added the
parameter so the merge uses the right levels, and it is correct only when
optimize passes the right langid, so it is left unchanged. The SQL_SELECT_ALL_LANGID
statement is still used by the integrity check.

Oracle result: `fts4langid-2.2` fails. After 'optimize', segdir should contain 9
rows (one per language), but only language 0 is merged so the count differs.
