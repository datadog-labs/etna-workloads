repro.sql creates an empty table (`CREATE TABLE t0;`) and runs `SELECT COUNT(*) FROM t0 AS tt0 WHERE (4==(3/0));`.
Clean build: returns count 0. Buggy build: fails with an "Internal error: Assertion failed: context.selectivity == Some(0.0)" in the analysis code, because selectivity is None when the predicate can't be folded (divide by zero).
