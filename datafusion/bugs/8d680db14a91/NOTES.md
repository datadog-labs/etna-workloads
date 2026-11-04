Reproducer for the null-aware anti-join (`NOT IN`) dynamic-filter bug.

repro.sql writes two small parquet files (outer ids 1,2,3; inner eids 2,NULL) and runs
`id NOT IN (SELECT eid ...)` with join dynamic filter pushdown and parquet `pushdown_filters` on.

- df-clean: zero rows (the inner NULL makes NOT IN unknown for every row).
- df-buggy: returns ids 1 and 3, because the pushed filter drops the probe-side NULL before the join sees it.
