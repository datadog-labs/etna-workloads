# Rationale
All in src/backend/executor/nodeModifyTable.c (fix.patch hunks for the same file):

1. ExecDelete(): ExecDeletePrologue called with NULL instead of `tmresult` (hunk "epqreturnslot, tmresult"). BEFORE ROW DELETE trigger skipping the delete no longer reports TM_Ok to the caller.
2. ExecCrossPartitionUpdate(): for MERGE (`!tuple_deleted`), returns `false` instead of `*tmresult == TM_Ok` (hunk `return *tmresult == TM_Ok`). A BR trigger that suppresses the delete is treated as a concurrent update.
3. ExecUpdateAct(): MERGE retry path returns `TM_Updated` instead of `result` (hunk `return result`). MERGE then retries/re-evaluates instead of treating the trigger-skipped row as done.

Together these restore the bug in cross-partition MERGE UPDATE with BEFORE ROW triggers.

Failing oracle case: src/test/regress||merge
