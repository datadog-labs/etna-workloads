# Rationale

File: src/backend/commands/tablecmds.c, function PreCommit_on_commit_actions (the only hunk in fix_impl.patch).

Change: the ONCOMMIT_DROP case no longer collects OIDs. It calls performDeletion() on each relation right away, inside the loop over on_commits. That is the pre-fix code. The batched code is removed: the oids_to_drop list, the ObjectAddresses build-up, performMultipleDeletions() and the assert loop. The snapshot push/pop that the current code has is kept around the per-relation performDeletion().

Why this brings the bug back: ON COMMIT DROP relations are dropped one at a time, interleaved with the scan of on_commits. When a parent and its partitions or inheritance children are all ON COMMIT DROP, dropping one with DROP_CASCADE can remove the others. Dependencies are then handled wrongly, and the later entries can hit relations that are already gone or have dependency problems. The fix gathered all the relations and dropped them in one performMultipleDeletions call.

Failing oracle case: src/test/regress||temp
