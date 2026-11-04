Reproducer for the null-aware `NOT IN` bug (push_down_filter inferring a predicate onto the subquery side).

`repro.sql` creates `nai_outer(3),(7)` and `nai_inner(NULL)`, then runs
`SELECT id FROM nai_outer WHERE id > 5 AND id NOT IN (SELECT id FROM nai_inner)`.

- df-clean: zero rows (the subquery contains NULL, so NOT IN is UNKNOWN).
- df-buggy: returns row 7, because `id > 5` is inferred onto the subquery side and drops its NULL.
