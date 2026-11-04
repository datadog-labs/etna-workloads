repro.sql runs `GROUP BY GROUPING SETS(())` aggregates (a SUM over generate_series(10) and a COUNT(*) over a small table).

Clean build: returns 55 and 2.
Buggy build: both queries fail with "Arrow error: number of columns(1) must match number of fields(2) in schema". The injection sends the empty grouping set to the no-grouping aggregate stream, which doesn't emit `__grouping_id`.
