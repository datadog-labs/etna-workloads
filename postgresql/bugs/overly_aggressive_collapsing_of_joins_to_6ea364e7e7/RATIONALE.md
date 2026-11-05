# Rationale

File: src/backend/optimizer/prep/prepjointree.c, function remove_useless_results_recurse().

Two hunks, both tracing to the fix_impl.patch hunks in the same function that added `find_dependent_phvs_in_jointree` checks:
1. FromExpr case: RTE_RESULT children are dropped from the fromlist again without checking whether a sibling references PHVs evaluated at that RTE_RESULT.
2. JOIN_INNER case: an RTE_RESULT on the left is collapsed without checking whether the right input has lateral references to PHVs computed at the RTE_RESULT.

PHVs get reassigned to the join, which is too late for the sibling's lateral use, so the joins are over-aggressively collapsed (planner error or wrong plan).
The helper function itself is left in place (now unused except for its definition; it is still declared and used elsewhere or harmlessly).

Failing oracle case: src/test/regress||join
