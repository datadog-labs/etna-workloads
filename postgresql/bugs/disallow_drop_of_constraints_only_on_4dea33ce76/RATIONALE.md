# Rationale

## src/backend/commands/tablecmds.c, ATExecDropConstraint()
Traces to the fix_impl.patch hunk that removes the "cannot remove constraint from only the partitioned table when partitions exist" check in ATExecDropConstraint. I re-added that check just before the loop over children. `ALTER TABLE ONLY parted DROP CONSTRAINT` now errors when partitions exist, which is the bug.

The other hunks of fix_impl.patch (ATPrepDropNotNull) are not reproduced. DROP NOT NULL has since been rewritten (ATExecDropNotNull now takes `recurse`), so the old function no longer exists.

## Failing oracle cases
- src/test/regress||alter_table
