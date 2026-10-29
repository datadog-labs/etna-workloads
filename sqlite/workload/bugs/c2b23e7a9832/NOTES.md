repro.sql builds a WITHOUT ROWID table t3 with PRIMARY KEY(a,b,c), runs ANALYZE, fakes
sqlite_stat1 as '10000 5000 2000 10', reloads it with ANALYZE sqlite_master, then runs
EXPLAIN QUERY PLAN for `WHERE b=345 ORDER BY a`.
Clean: `SEARCH t3 USING PRIMARY KEY (ANY(a) AND b=?)` (skip-scan).
Buggy: `SCAN t3`. The stat1 row for a WITHOUT ROWID PK isn't applied, so skip-scan isn't chosen.
