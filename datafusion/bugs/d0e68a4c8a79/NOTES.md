repro.sql uses an aggregate (`SUM(v)`) that appears only in QUALIFY, not in the SELECT list.
The injected bug stops the planner from searching QUALIFY for aggregates.
- Clean: the second query succeeds and returns id=3. The first errors with "QUALIFY clause requires window functions", which is the expected error.
- Buggy: both queries fail with "Column in QUALIFY must be in GROUP BY or an aggregate function ... users.v".
