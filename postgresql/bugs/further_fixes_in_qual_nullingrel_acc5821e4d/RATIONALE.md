All changes are in src/backend/optimizer/plan/initsplan.c and trace to the three hunks of fix_impl.patch.

1. make_outerjoininfo(): removed `&& !bms_overlap(clause_relids, otherinfo->syn_lefthand)` from the identity-3 test (hunk 1). Identity 3 is then applied even when the clause references the other join's syntactic LHS, so the ordering restriction is wrongly dropped.
2. deconstruct_distribute_oj_quals(), `above_sjinfo` branch: add_nulling_relids now uses othersj->min_righthand instead of sjinfo->syn_lefthand (hunk 2). The wrong Vars get the nulling bit.
3. deconstruct_distribute_oj_quals(), `below_sjinfo` branch: add_nulling_relids now uses othersj->min_righthand instead of othersj->syn_righthand (hunk 3). The wrong Vars get the nulling bit.

Failing oracle case: src/test/regress||join
