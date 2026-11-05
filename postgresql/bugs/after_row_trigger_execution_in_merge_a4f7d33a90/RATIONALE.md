# Rationale

File: src/backend/executor/nodeModifyTable.c, function ExecMergeMatched (CMD_UPDATE case, non-INSTEAD-OF branch).

Traces to the single fix_impl.patch hunk: right after ExecUpdateAct(), the fix added a check for `updateCxt.crossPartUpdate` that bumps mt_merge_updated and returns early (in current code: sets rslot = cpUpdateReturningSlot and `goto out`). I removed that block.

Why this brings the bug back: with a cross-partition MERGE UPDATE (turned into DELETE + INSERT), execution falls through to `if (result == TM_Ok) ExecUpdateEpilogue(...)`. That fires AFTER ROW UPDATE triggers (and related post-update work) on the old partition's tuple, which is wrong. The RETURNING slot also isn't returned.

Failing oracle cases: src/test/regress||triggers
