repro.sql sets target_partitions=1 and runs `CORR(x, y)` grouped by `g` over `(SELECT * FROM stream_test ORDER BY g LIMIT 10000)`. That input is sorted, so the planner picks streaming aggregation (ordering_mode=Sorted), which emits groups with EmitTo::First.

- Clean build: returns the correct rows (1 -> 1.0, 2 -> NULL, 3 -> 1.0).
- Buggy build: fails with "Arrow error: Invalid argument error: all columns in a record batch must have the same length". The CORR accumulator no longer drains its state vectors on partial emits.
