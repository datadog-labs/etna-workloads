Reproducer (repro.sql): LEFT JOIN whose right table is driven by an index with `z IN (5,0)` (join2-14.0).
Clean: 2 rows. Buggy: a spurious extra row `2|NULL|NULL|1|NULL|5` (the IN-loop cursor isn't NullRow'd for the unmatched LEFT JOIN row, so stale t2 data leaks).
