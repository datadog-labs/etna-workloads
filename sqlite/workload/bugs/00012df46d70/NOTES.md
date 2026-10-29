repro.sql: WITHOUT ROWID table with a UNIQUE column b; UPDATE sets b to a duplicate value without changing the PK.
Clean: "UNIQUE constraint failed: t.b", rows unchanged, integrity_check ok, exit 1.
Buggy: the UPDATE skips uniqueness checks on all indexes when the PK is unchanged, so the duplicate is accepted
(rows 1|1|0, 2|1|0), integrity_check reports "non-unique entry in index", exit 0.
