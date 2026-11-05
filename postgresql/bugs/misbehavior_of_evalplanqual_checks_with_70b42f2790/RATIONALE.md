# Rationale

Changed hunk: src/backend/executor/nodeModifyTable.c, ExecInitModifyTable().
Traces to the fix.patch hunk that makes ExecInitModifyTable pass `node->resultRelations` to EvalPlanQualInit(). It now passes NIL, as before the fix.

Effect: the EPQ state has no list of result relations, so no result relation is marked "blocked" in relsubs_blocked[]. With multiple result relations, an EPQ recheck on one target relation lets the other target relations return stale tuples, because they are not marked as having no tuple. This is the original misbehavior.

Failing oracle case: src/test/isolation||eval-plan-qual
