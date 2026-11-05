# Rationale

File: src/backend/utils/adt/orderedsetaggs.c, function percentile_cont_multi_final_common (loop over pct_info).

Traces to the single implementation hunk of fix.patch. I restored the pre-fix logic. It uses
`target_row`/`need_lerp` instead of comparing first_row/second_row with rownum. When the
`first_row > rownum` branch runs, `second_val` is no longer advanced. When `first_row < rownum`, the
code still does `first_val = second_val` (the old unconditional else). `second_row` is fetched
based on need_lerp alone. Consecutive percentiles that interpolate between the same two
input rows, or whose first_row is already behind rownum, therefore get a wrong first_val
(stale second_val). That is the corner-case bug.

Failing oracle case: src/test/regress||aggregates
