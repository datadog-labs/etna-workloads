# Rationale

File: src/backend/commands/tablecmds.c, function ATExecAttachPartition (last part, default partition handling).

Traces to the fix.patch hunk that removes the second `defaultPartOid = get_default_oid_from_partdesc(...)` re-read and adds `Assert(!cmd->bound->is_default)`. The reversal re-reads the default partition OID after the new partition has been attached, and drops the Assert. After the CommandCounterIncrement the re-read partdesc no longer gives the OID that was locked earlier. The default partition's updated constraint is then not validated, so ATTACH PARTITION succeeds even when the default partition holds rows that belong in the new partition.

The other fix hunks (rename, recursion, lock level) are refactoring and are not reverted.

Failing oracle case: src/test/regress||alter_table
