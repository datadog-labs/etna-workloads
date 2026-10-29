repro.sql: queries an indexed table with a row-value range comparison using a nonexistent collation:
`SELECT * FROM f1 WHERE (?, ? COLLATE nose) > (a, b)` (index on f1(a,b)).
Clean shell: "no such collation sequence: nose", exit 1.
Buggy shell: whereRangeVectorLen dereferences a NULL CollSeq, so it segfaults (exit -11).
