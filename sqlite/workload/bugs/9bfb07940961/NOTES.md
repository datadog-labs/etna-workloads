repro.sql: a table with `x NOT NULL DEFAULT NULL`, then `REPLACE INTO t1 DEFAULT VALUES`.
Clean shell: fails with "NOT NULL constraint failed: t1.x" (exit 1, 0 rows).
Buggy shell: REPLACE substitutes the NULL default, so a NULL gets into the NOT NULL column (exit 0, 1 row with x NULL).
