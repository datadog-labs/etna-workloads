# Rationale

Fix hunk reversed: src/alter.c, the condition guarding the post-ADD COLUMN
quick_check verification. The fix replaced `pParse->bDiscardCheck` with
`pNew->pCheck!=0` (the bDiscardCheck flag in build.c/sqliteInt.h no longer
exists, so those hunks cannot be reversed directly). In 3.54.1 I removed the
`pNew->pCheck!=0 ||` term, so a newly added CHECK constraint no longer
triggers verification; only the generated-NOT-NULL and STRICT cases do.
This is the pre-fix behaviour: CHECK constraints that are kept by the parser
were never verified against existing rows.

Failing oracle cases: alter3-9.2, 9.3, 9.4, 9.5, 9.7 (the ADD COLUMN with
CHECK(a!=1) succeeds instead of failing "CHECK constraint failed", leaving
column c behind, which causes later "duplicate column name" and wrong
error-message results).
