# Rationale

File: src/backend/optimizer/plan/analyzejoins.c, function remove_rel_from_eclass (called from remove_rel_from_query).

Traces to the fix.patch hunks that add the remove_rel_from_eclass call in remove_rel_from_query and the new function body. In current code that function is shared with self-join removal (sjinfo == NULL). I added an early `return` when sjinfo != NULL (left-join removal), after the PHV-stripping step. So for left-join removal, ec_relids, em_relids, dead members, ec_sources and ec_derives are no longer cleaned of the removed relid/ojrelid. This restores the original bug of stale EquivalenceClass references after left join removal.

Failing oracle case: src/regress||join
