repro.sql: `t1 INNER JOIN t2 ON (0) RIGHT OUTER JOIN t3` with only t3 populated.
Correct result: one row `|` `|t3val` (NULLs for t1/t2). The buggy shell treats the
constant-false ON term as "no rows" and skips the loop, returning no rows.
