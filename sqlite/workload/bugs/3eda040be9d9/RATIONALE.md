# Rationale

Fix hunk reversed: src/insert.c, removal of `sqlite3TableAffinityStr(v, pTab)` after the
OP_MakeRecord that fills the transient table (srcTab) in `INSERT ... SELECT` from a table
into itself. In 3.54.1 the equivalent code is in `sqlite3Insert()` (useTempTable branch);
I re-added `sqlite3TableAffinity(v, pTab, 0)` right after that OP_MakeRecord, which attaches
the destination table's column-affinity string to the record. The temp table holds the
SELECT's columns, not the target's columns, so affinities are applied to the wrong columns
(e.g. TEXT value '01' hit with INTEGER PRIMARY KEY's numeric affinity -> 1).
The doc-comment hunks of the fix are not behavioural and were not reverted.

Oracle: tkt1536-1.2 fails (with the assertion `zAffinity[0]==0 || pRec<=pLast` in
OP_MakeRecord, since the affinity string is longer than the record's column count);
tkt1536-1.1 passes.
