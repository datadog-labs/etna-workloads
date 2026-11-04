repro.sql runs GROUP BY ALL queries whose select list wraps an aggregate in an expression (COUNT(*) AS c, COUNT(*) + 1, SUM(x) * 2).
Clean build: queries return correct results (5; per-group counts; per-group sums).
Buggy build: the injected filter only recognises a top-level aggregate or an aliased aggregate. The aggregate nested in an expression is added to the grouping keys, so every query fails with "Physical plan does not support logical expression AggregateFunction(...)".
