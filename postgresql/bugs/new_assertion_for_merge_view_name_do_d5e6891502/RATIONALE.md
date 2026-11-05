Changed: src/backend/executor/nodeModifyTable.c, ExecMergeMatched().

Traces to the fix.patch hunk that removed `Assert(resultRelInfo->ri_TrigDesc);` inside `if (oldtuple != NULL)`. The fix removed this assertion because a view target with MERGE ... DO NOTHING has no triggers, so ri_TrigDesc is NULL. I re-added the assertion, so the assert fires for that case.

Failing oracle case: src/test/regress||updatable_views
