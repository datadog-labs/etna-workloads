# Rationale

All changes are in src/backend/executor/nodeModifyTable.c. They trace to the fix.patch hunks that move ExecUpdatePrepareSlot (which fills in GENERATED columns) into ExecUpdateAct at `lreplace:`. The I/U-split hunks are not reversed: the current code is already built around them, and the split is not needed to bring the bug back.

1. `ExecUpdateAct`: removed the `ExecUpdatePrepareSlot()` call after `lreplace:`. This traces to the fix hunk that adds it there. Without it, GENERATED values are no longer recomputed when the tuple is retried or moved.
2. `ExecUpdate`: restored a single `ExecUpdatePrepareSlot()` call before the `redo_act:` label. This traces to the fix hunk that removes it from the `else` branch. The slot is prepared only once. After EvalPlanQual produces a new candidate tuple and the code jumps to `redo_act`, the stored generated columns are not recomputed, so they are stale.
3. `ExecMerge` (the MERGE update path): restored the `ExecUpdatePrepareSlot(resultRelInfo, newslot, ...)` call before `ExecUpdateAct`. This traces to the fix hunk that removes it, and keeps MERGE working as it did before the fix.

Failing oracle case: src/test/isolation||eval-plan-qual
