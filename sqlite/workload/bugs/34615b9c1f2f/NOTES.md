repro.sql: LEFT JOIN whose right side is a subquery over a multi-row VALUES clause (a co-routine).
After a non-matching outer row (t3.id=0) the pseudo-cursor's nullRow flag stays set,
so later matching rows return x.c0 as NULL.
Clean: 0|, 3|1, 3|1, 0|, 5|1, 5|1. Buggy: x.c0 is empty (NULL) on every row.
