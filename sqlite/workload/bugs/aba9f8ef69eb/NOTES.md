Reproducer (repro.sql) mirrors nulls1-12.0–12.9: a TEXT column with 12 NULLs plus 'A', indexed and ANALYZEd,
then `SELECT DISTINCT ... INDEXED BY i0 ORDER BY c0 DESC NULLS FIRST` (and ASC NULLS LAST).
Clean shell returns NULL and A for the first query, and A and NULL for the second.
Buggy shell drops 'A' from the first query (only NULL) and drops NULL from the second (only A),
because the skip-ahead DISTINCT seek is resolved before the bignull loop-back.
