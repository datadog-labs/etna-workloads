# Rationale

File: src/backend/optimizer/plan/analyzejoins.c, function remove_self_joins_recurse.

Traces to the fix.patch hunks in remove_self_joins_one_group, which skipped
`root->parse->resultRelation` as either the removed (r) or kept (k) relation.
In REL_18_6 that exclusion moved to the candidate collection in
remove_self_joins_recurse (`varno != root->parse->resultRelation`). I removed that
condition, so the result relation can again take part in self-join elimination.
That brings back the bug: EvalPlanQual and RETURNING treat the result relation
differently, so eliminating it gives wrong behavior.

Failing oracle case: src/test/regress||join
(updatable_views still passes.)
