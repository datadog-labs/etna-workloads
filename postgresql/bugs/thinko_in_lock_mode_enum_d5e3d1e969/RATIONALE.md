# Rationale
File: src/backend/access/heap/heapam.c, function DoesMultiXactIdConflict.
Traces to fix.patch hunks: the `wanted = tupleLockExtraInfo[lockmode].hwlock` conversion and the `DoLockModesConflict(memlockmode, wanted)` call.
Bug restored: the LockTupleMode `lockmode` is passed directly to DoLockModesConflict, which expects a LOCKMODE. The enum values are not the heavyweight lock mode numbers, so conflict checks are wrong. (The `wanted` variable was removed.)

Failing oracle case: src/test/isolation||tuplelock-conflict
