repro.sql builds the parquet-backed join tables from the upstream slt and runs LEFT/RIGHT ANTI joins with filter pushdown enabled.

Differences (buggy vs clean):
- EXPLAIN of the NOT IN + ORDER BY LIMIT query: buggy also puts a DynamicFilter on the anti join's right (non-output) scan.
- `... LEFT ANTI JOIN ... WHERE false` and the RIGHT ANTI equivalent (max_passes=0, join_reordering=false): buggy returns count 5, clean returns the correct 0, because the parent filter is pushed to the non-output side and removed from above the join.
