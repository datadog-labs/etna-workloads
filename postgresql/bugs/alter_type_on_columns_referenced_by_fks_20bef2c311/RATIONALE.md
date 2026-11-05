# Rationale

File: src/backend/commands/tablecmds.c, function ATPostAlterTypeCleanup (hunks 2-4 of fix_impl.patch).
- Constraint/index OIDs are no longer collected into an ObjectAddresses set; they are again dropped one at a time with performDeletion(), all constraints first, then all indexes (reverse of the performMultipleDeletions hunk).
- The statistics objects still go into the multi-deletion set (code added after the fix).
- The constraint list is appended in discovery order (the FK-first ordering of hunk 1 is already absent in current code, which relies on the multi-deletion).

With FKs on partitioned tables, a constraint is dropped before the dependent FK clones/indexes in the wrong order, so ALTER COLUMN TYPE on a referenced column fails with a dependency error.

Failing oracle case: src/test/regress||foreign_key (expected)
