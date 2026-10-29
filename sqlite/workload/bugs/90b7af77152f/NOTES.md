`repro.sql` creates a table with six rows and runs `select a from (select distinct a, b from t)`.

- The clean shell returns three rows (`1`, `1`, `1`), one for each distinct (a,b) pair.
- The buggy shell returns one row (`1`). The injected patch lets the unused-subquery-column optimization run on a DISTINCT subquery. That drops column `b`, so DISTINCT then collapses on `a` alone.
