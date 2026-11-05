# Rationale

The original fix hunks have been reworked upstream (outer-join rework in 2023): the early
"if min_righthand is empty, use syntactic RHS" step in make_outerjoininfo() no longer exists
in that form, and the join_is_legal() LHS-overlap check was restructured. Its modern
equivalent is the "degenerate clause" rule in the lower-OJ-in-our-RHS test of
make_outerjoininfo().

## src/backend/optimizer/plan/initsplan.c, make_outerjoininfo()
Traces to the fix.patch hunk at initsplan.c ~1128 (force min_righthand to the syntactic
RHS for a degenerate join clause that mentions no RHS rels). I removed the condition
`!bms_overlap(clause_relids, otherinfo->min_lefthand)` from the "preserve ordering" test
for a lower OJ in our RHS. Without it, a clause that doesn't reference the lower join's
LHS (a degenerate clause) no longer forces ordering to be preserved, so min_righthand can
omit the lower OJ and join order enforcement is confused again (LHS can end up on the wrong
side of an outer join / wrong plans for nested degenerate outer joins).

## Failing oracle cases
- src/test/regress||join
