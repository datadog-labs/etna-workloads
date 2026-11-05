# Rationale

Hunk: src/backend/optimizer/prep/prepjointree.c, find_dependent_phvs_walker()
Traces to the fix.patch hunk that intersects phv->phrels with the baserels set before bms_equal().
Reverted to the pre-fix comparison `bms_equal(context->relids, phv->phrels)`. Stale outer-join relids in a
PHV's phrels then prevent a match, so find_dependent_phvs() misses dependent PHVs and a RESULT RTE is
wrongly removed, which is the bug the fix removed.
(The baserels plumbing is left in place but unused for the comparison; only the logic is reverted.)

Failing oracle case: src/test/regress||join
