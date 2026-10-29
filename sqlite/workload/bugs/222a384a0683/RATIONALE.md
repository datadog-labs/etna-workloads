# Rationale

Fix hunk (src/insert.c): in sqlite3GenerateConstraintChecks, run
sqlite3TableAffinity() at the top of the per-index loop, before the UPSERT
bypass logic, so affinity is applied before any constraint check.

In 3.54.1 the UPSERT code was restructured (the pUpIdx/upsertBypass code is
gone; the target index is picked per iteration by pUpsertClause). The
equivalent reversal is the one-line change in the index loop:
`if( bAffinityDone==0 )` -> `if( bAffinityDone==0 && pUpsertClause==0 )`.
When an UPSERT clause applies to the index being processed, the affinity
transformation is no longer emitted ahead of that index's record build and
uniqueness check (the pre-fix behaviour: affinity skipped on the UPSERT path).
The index record is built from unconverted values (e.g. TEXT '1' in an INT
column), producing a corrupt index. The other affinity call sites (CHECK
constraints, end of function for rowid tables) are untouched; for WITHOUT ROWID
tables none runs afterwards.

Oracle failures: upsert1-600 and upsert1-610 (integrity_check reports
"wrong # of entries in index", "TEXT value in t1.a", "row 2 missing from
index") — the ticket's corrupt-index symptom.
