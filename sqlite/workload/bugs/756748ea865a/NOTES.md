Reproducer (repro.sql): a WITHOUT ROWID table with PRIMARY KEY(a) gets a column b added via ALTER TABLE, then EXPLAIN QUERY PLAN runs `SELECT * FROM dual, t1 WHERE a=10 AND b=10`.

Clean shell: `SEARCH t1 USING PRIMARY KEY (a=?)`.
Buggy shell: `SEARCH t1 USING PRIMARY KEY (a=? AND b=?)`. The planner wrongly treats the non-key content column b as an ordered index column. This is test without_rowid1-14.2.
