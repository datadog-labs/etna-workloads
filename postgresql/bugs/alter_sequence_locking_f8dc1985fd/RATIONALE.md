# Rationale

Both hunks are in src/backend/commands/sequence.c and trace to fix_impl.patch (the lock level introduced for ALTER SEQUENCE).

1. `AlterSequence()`: `RangeVarGetRelidExtended` now takes `AccessShareLock` instead of `ShareRowExclusiveLock`. This traces to the fix hunk that changed `RangeVarGetRelid(..., AccessShareLock, ...)` to use `alter_sequence_get_lock_level()`. ALTER SEQUENCE no longer conflicts with concurrent nextval() and similar calls.
2. `lock_and_open_sequence()`: `LockRelationOid` takes `AccessShareLock` instead of `RowExclusiveLock`. This traces to the hunk that changed `AccessShareLock` to `RowExclusiveLock` there. nextval() and similar calls no longer conflict with ALTER SEQUENCE's lock.

Together these bring back the bug where ALTER SEQUENCE did not block, or get blocked by, concurrent sequence use.

Failing oracle case: src/test/isolation||sequence-ddl
