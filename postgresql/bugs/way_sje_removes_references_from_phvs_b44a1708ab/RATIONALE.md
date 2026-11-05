# Rationale
File: src/backend/optimizer/plan/analyzejoins.c, function remove_rel_from_query.
Traces to the fix.patch hunk adding `replace_varno((Node *) phv->phexpr, relid, subst)` (now `ChangeVarNodesExtended(phv->phexpr, ...)`). I removed that call, so when SJE removes a relation, the PHV's expression still references the removed relid. This brings back the stale-reference bug.

Failing oracle case: src/test/regress||join
