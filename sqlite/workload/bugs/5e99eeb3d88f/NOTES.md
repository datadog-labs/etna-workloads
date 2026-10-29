repro.sql: runs the 9.7.2 query from existsexpr.test (EXISTS subquery with LIMIT 1 OFFSET 1).
The clean shell returns `2`. The buggy shell applies EXISTS-to-JOIN despite the OFFSET, so it returns `1`.
