# Rationale

## src/backend/executor/nodeModifyTable.c, ExecOnConflictUpdate()
Traces to the fix.patch hunk replacing `&tuple.t_data->t_ctid` with `&tuple.t_self`
in the ExecUpdate call. In current code the fixed form passes `conflictTid` (the
locked tuple's TID). I reverted it to pass the locked tuple's own `t_data->t_ctid`
(via the BufferHeapTupleTableSlot of `existing`). If the target tuple was updated in
this command after locking (e.g. via a wCTE in the SET clause), t_ctid points to the
newer version, so ExecUpdate works on the wrong tuple version and AFTER UPDATE
triggers break.

Failing oracle cases (confirmed by oracle run): src/test/regress||triggers, src/test/regress||with.
