# Rationale

File: src/backend/executor/nodeModifyTable.c, function ExecMergeMatched (WHEN MATCHED UPDATE branch).
Traces to the single hunk in fix.patch: the ExecUpdateAct call passes `canSetTag`
(fix) instead of `false`. Reverted to pass `false`, so a cross-partition update inside MERGE
(ExecCrossPartitionUpdate -> ExecInsert with canSetTag) never counts the row, giving a wrong
MERGE command tag/row count.

Failing oracle case: src/test/regress||merge
