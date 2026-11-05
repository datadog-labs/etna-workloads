# Rationale

All changes are in src/backend/commands/tablecmds.c and reverse hunks of fix.patch.

- CloneFkReferenced: fkRel opened with AccessShareLock again (hunk "We need the same lock level that CreateTrigger will acquire"). Lock escalation to ShareRowExclusiveLock later in CreateTrigger.
- DetachPartitionFinalize: reintroduced the unneeded parentConTup syscache lookup/release, reintroduced the `attmap` (build_attrmap_by_name) applied to conkey (wrong: conkey already refers to partRel columns, so the wrong column names are chosen when column order differs), refdRel opened with AccessShareLock and closed with AccessShareLock instead of ShareRowExclusiveLock/NoLock.
- addFkRecurseReferencing: the lock Assert added by the fix is removed. The Assert in addFkRecurseReferenced is deliberately kept: with the build's assertions on, it detects the weaker lock on refdRel.

Failing oracle case: src/test/regress||foreign_key (assertion failure from the weaker lock in DetachPartitionFinalize -> addFkRecurseReferenced).
