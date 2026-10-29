repro.sql: fts5 table with columns (a, b); the query matches 'xyz' in column a, and snippet() is asked for column b with a 5-token window.
Clean: `1 2 3 4 5...`. Buggy: the whole `1 2 3 4 5 6 7 8 9 10 11 12 13` (the missing `nDocsize>nToken` check and the missing xColumnSize call break the truncation).
