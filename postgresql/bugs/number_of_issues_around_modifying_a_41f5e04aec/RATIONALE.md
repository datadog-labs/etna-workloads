# Rationale
Hunks (traced to fix_impl.patch):
1. src/backend/access/heap/heapam_handler.c, heapam_tuple_lock: restored `return TM_Invisible` (without setting tmfd->xmax/cmax) instead of TM_SelfModified when following an update chain onto a tuple created by our own later command. Matches the heapam_handler.c hunk.
2. src/backend/executor/nodeModifyTable.c, ExecDelete and ExecUpdate: removed the `case TM_SelfModified` handling after table_tuple_lock (matches the two nodeModifyTable.c hunks adding those cases). Without it, a self-modified tuple reached via EPQ chain-following hits the default error / invisible path instead of being ignored or raising the triggered-data-change error.
(The errmsg wording and comment-only hunks were not reverted; not behavioral beyond this.)

Failing oracle case: src/test/isolation||eval-plan-qual (regress triggers still passes).
