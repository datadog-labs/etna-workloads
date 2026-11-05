# Rationale

File: src/backend/optimizer/plan/analyzejoins.c, function remove_rel_from_query (PlaceHolderVar loop).

Traces to the fix.patch hunk in the same loop. The fix deletes placeholders whose
ph_needed is a subset of joinrelids, instead of only updating them. In the current
code that is the `if (sjinfo != NULL && bms_is_subset(...)) {foreach_delete_current ...}` branch.
I removed that branch, so no-longer-needed PHVs stay in placeholder_list and are only
adjusted. That brings back the bug: stale PHVs survive join removal and can break planning.

Failing oracle case: src/test/regress||join
