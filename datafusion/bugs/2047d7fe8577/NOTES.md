repro.sql runs `WHERE x > 2 OR EXISTS (...)` / `OR x IN (...)` against a subquery table with duplicate keys (t2 has two rows with value 1).
The clean build uses a LeftMark join, so each t1 row appears once. The buggy build emulates the mark with a LEFT join, so t1 row (1,'a') is returned twice in both queries.
