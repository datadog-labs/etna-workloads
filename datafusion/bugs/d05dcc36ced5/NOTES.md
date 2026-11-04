Reproducer for the `approx_percentile_cont_with_weight` null-filtering bug. `repro.sql` holds the two queries the fix added to aggregate.slt.

- Mixed nulls in values and weights: clean returns 2.0. Buggy returns 1.5, because null rows are not filtered out of both inputs.
- All-null input: clean returns NULL. Buggy returns 0.0.

`./check.sh` shows both differences. Both builds exit with status 0.
