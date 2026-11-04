Reproducer for the correlated scalar subquery bug: `regr_count` and `approx_distinct` must return 0, not NULL, on empty input.
Decorrelation turns the subquery into a left join and fills in a default for unmatched outer rows. The buggy build special-cases only `count`.

repro.sql runs both aggregates in correlated scalar subqueries, once in the projection and once in a WHERE filter.
- df-clean returns 0 for unmatched rows (t1_id 22 and 44), and the filter `= 0` returns 22 and 44.
- df-buggy returns NULL for those rows, and the filter returns no rows.
