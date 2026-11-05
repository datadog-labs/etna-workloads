# Rationale
File: src/backend/optimizer/prep/prepjointree.c, function remove_useless_results_recurse(), JOIN_SEMI case.

Traces to the fix.patch hunk that removed `Assert(!find_dependent_phvs(root, varno))` from the JOIN_SEMI case.
I re-added it as `Assert(!find_dependent_phvs(root, varno, baserels));`, using the current signature. The JOIN_RIGHT case and the comment changes are not restored. JOIN_RIGHT is already gone in current code, and the comments don't affect behavior.

The Assert is bogus: a PHV to be evaluated at the semijoin's RHS can legitimately appear in the semijoin qual. With assertions enabled, the planner then crashes.

Failing oracle case: src/test/regress||join
