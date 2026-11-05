# Rationale

File: src/backend/executor/nodeModifyTable.c, function ExecMergeMatched (CMD_UPDATE and CMD_DELETE cases; 2 hunks).

Traces to both hunks of fix.patch. In current code the fix reads `if (result == TM_Ok) goto out;` (formerly `return true`) after ExecUpdatePrologue/ExecDeletePrologue fail. I restored the old code: always `break`, treating a BEFORE ROW trigger that returns NULL like a concurrent update/delete. The action is then not counted or reported correctly (wrong MERGE command tag / row count) when a BEFORE ROW trigger blocks it.

Failing oracle case: src/test/regress||merge
