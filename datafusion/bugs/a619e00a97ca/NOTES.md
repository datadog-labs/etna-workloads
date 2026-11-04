repro.sql runs the queries added by the upstream fix: aggregates over a CTE built on `generate_series(...)` with a `WHERE 1 = 1` filter.

With the bug, the generate_series table provider ignores the projection pushed into the scan. For `count(*)`, the scan should project zero columns, but it still returns one.

- df-clean: `count(*)` returns 10.
- df-buggy: `count(*)` fails with an "Internal error: Physical input schema should be the same as the one converted from logical input schema" (1 field vs 0). The other two queries still return the same results in both builds.
