repro.sql creates a table with NaN doubles and runs `max(x), min(x) ... GROUP BY "row"` (the grouped
path uses the PrimitiveGroupsAccumulator).

Clean build: NaN for both max and min in every group (including a group mixing 1.0 and NaN).
Buggy build: the `<`/`>` comparison ignores NaN, so group 1 returns the initial values
(-1.797e308 / 1.797e308) and group 2 returns 1.0.
