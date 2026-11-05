# Rationale

## Changed hunk
- File: `src/src/backend/commands/tablecmds.c`, function `DetachPartitionFinalize` (in REL_18_6 this holds the code that used to live in `ATExecDetachPartition`).
- Traces to the fix.patch hunk in `ATExecDetachPartition` that added the call `DropClonedTriggersFromPartition(RelationGetRelid(partRel));`.
- I removed that call. Triggers cloned onto the partition (`tgparentid` set) are no longer dropped when the partition is detached.
- The bug comes back: after DETACH PARTITION the detached table keeps the row triggers cloned from the parent. They keep firing, and they are still marked as clones of the parent's triggers.
- The now-unused static function is left in place. Only the call site changed.

## Failing oracle cases
- `src/test/regress||triggers` (FAIL in the oracle run; it passes without the change)

The diff in `logs/src_test_regress_.diffs` shows the cloned triggers surviving a detach:
- `drop trigger trg1 on trigpart3` after detach now reports "cannot drop trigger ... because trigger trg1 on table trigpart requires it". The expected result is "does not exist".
- Re-attaching the partition then fails with `trigger "trg1" for relation "trigpart3" already exists`.

The same run also shows a diff in `identity.out` ("tuple already updated by self" on DETACH PARTITION). I did not investigate it. It is probably a side effect of the same change, but I haven't confirmed that.
