repro.sql: creates a STRICT table with a VIRTUAL column over a STORED generated column, then inserts a row and selects it.
Clean: prints `4|2|1`. Buggy: `INSERT` fails with "cannot store BLOB value in INT column t4.b" (OP_TypeCheck P3 no longer set, so generated columns are checked before being computed).
