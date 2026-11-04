repro.sql runs three recursive CTEs (from the new cte.slt tests, issue #22249) where the outer query selects only `v` from a CTE whose recursive term filters on `k` or `v`.

- clean: returns rows 10, 20 (and 10, 10 for the UNION case).
- buggy: the first query silently returns only 10 (wrong result). The other two fail with "Arrow error: Schema error: project index 1 out of bounds, max field 1".

Cause: the injected bug pushes the outer query's required columns into the recursive term, pruning columns it still needs.
