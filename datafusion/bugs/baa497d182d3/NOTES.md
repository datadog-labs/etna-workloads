Reproducer: writes two small parquet files (probe: 11, 22, NULL; build: 11, NULL), then runs a
null-equal join (`IS NOT DISTINCT FROM`) with join dynamic filter pushdown and parquet filter pushdown enabled.

Difference: clean returns rows (11,11) and (NULL,NULL). Buggy returns only (11,11), because a dynamic
filter derived from the build side is pushed to the probe scan and prunes the probe-side NULL key.
(The EXPLAIN output is the same in both builds, so only the query result differs.)
