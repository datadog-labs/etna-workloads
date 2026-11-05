# Rationale
File: src/backend/optimizer/plan/initsplan.c, function make_outerjoininfo().
Traces to the sole fix.patch hunk: the full-join branch in the join_info_list loop.
The fix expanded min_lefthand/min_righthand to cover a full join (including its ojrelid) overlapping the LHS/RHS. I restored the old behavior: full joins are ignored (`continue`), so a full join inside the RHS of a left join can be associated into/out of, producing the planner failure.

Failing oracle case: src/test/regress||join
