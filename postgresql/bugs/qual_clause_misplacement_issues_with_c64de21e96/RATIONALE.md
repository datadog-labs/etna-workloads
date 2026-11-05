# Rationale

## src/backend/optimizer/prep/prepjointree.c, is_simple_subquery()
Traces to the fix.patch prepjointree.c hunk in is_simple_subquery(). The fix replaced the old check
(for a LATERAL subquery below an outer join, refuse pullup if any level-1 var of the whole subquery
lies outside the outer join) with a finer-grained check. That check calls
jointree_contains_lateral_outer_refs() on the subquery's WHERE and JOIN/ON quals, including outer
joins inside the subquery. It also checks the targetlist's lateral refs when an outer join is above.
I restored the old check: `rte->lateral && lowest_outer_join != NULL`, then
`pull_varnos_of_level(subquery, 1)` must be a subset of the outer join's relids.

The per-qual and targetlist restrictions are gone, so pullup decisions for LATERAL subqueries
revert to the pre-fix logic. Plans change, and so do the results of the regression queries added
with the fix. jointree_contains_lateral_outer_refs() is left in place but is now unused.
I did not remove the postponed-qual machinery in initsplan.c, which has been reworked since.
So this reproduction is partial: it reverts the pullup-restriction half of the fix.

## Failing oracle cases
- src/test/regress||join
