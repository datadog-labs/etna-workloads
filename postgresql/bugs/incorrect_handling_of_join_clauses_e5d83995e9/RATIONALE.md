# Rationale

File: src/backend/optimizer/util/restrictinfo.c, function extract_actual_join_clauses.
Traces to the fix_impl.patch hunk in restrictinfo.c (the `rinfo->is_pushed_down || !bms_is_subset(required_relids, joinrelids)` check). In current code this logic lives in the macro RINFO_IS_PUSHED_DOWN(rinfo, joinrelids), which tests both is_pushed_down and required_relids vs joinrelids. I replaced it with a plain `rinfo->is_pushed_down` test. An outer-join clause pushed into a parameterized path below its join level (not flagged is_pushed_down) is then treated as a join qual rather than a filter at the lower join, giving wrong results/plans.

The createplan.c and header hunks only pass the join relids argument; the parameter is kept (now unused) to keep the change minimal.

Failing oracle case: src/test/regress||join
