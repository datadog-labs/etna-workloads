# Rationale

File: src/backend/optimizer/plan/initsplan.c, function make_outerjoininfo(), the "lower OJ in our RHS" block.

fix.patch hunk (adds `jointype == JOIN_ANTI ||` to the ordering-preservation test): reversed by removing
`jointype == JOIN_ANTI` from the condition that forces the lower OJ's full syntactic relset into min_righthand.

Adaptation: the current code has an extra clause, `!bms_overlap(clause_relids, otherinfo->min_lefthand)`,
added later (to avoid identical min_righthands). It also forces ordering preservation in the regression
case and masks the missing ANTI test. Removing only the ANTI test left the oracle passing. So that
clause is removed as well. It is not part of the original fix, but without removing it the original bug can't show.

Effect: when the current join is an antijoin, no ordering condition fires, and the identity-3 branch
is skipped because jointype != JOIN_LEFT. The antijoin's min_righthand then omits the lower OJ, so
the antijoin can be reordered with outer joins improperly.

Failing oracle case: src/test/regress||join
