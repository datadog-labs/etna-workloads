repro.sql builds t1(x) with rows 'a','A','A' and runs two count(CASE WHEN x='a'/x='A' ...) aggregates in one query.
Clean shell prints `1|2`. The buggy shell compares string literals case-insensitively in sqlite3ExprCompare(), treats the two count() calls as identical, and prints `1|1`.
