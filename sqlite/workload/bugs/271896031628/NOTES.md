repro.sql: TEXT-affinity column `a` with a unique index, queried with `a IN (SELECT x FROM b2)` where x is BLOB affinity and holds integer 1 while a holds text '1'.
Clean: both queries return no rows (no affinity conversion applied). Buggy: the indexed query applies TEXT affinity to the IN-subquery values, so it wrongly returns the row `idx|1`.
