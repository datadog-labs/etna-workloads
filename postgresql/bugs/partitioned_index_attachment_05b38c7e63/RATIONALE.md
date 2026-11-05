# Rationale

## src/backend/commands/indexcmds.c, IndexSetParentIndex / update_relispartition
Traces to the fix.patch hunks in indexcmds.c that add `update_relispartition(partRelid, OidIsValid(parentOid))` in IndexSetParentIndex and the new helper. I removed that call and the helper. In the pre-fix state IndexSetParentIndex did not maintain pg_class.relispartition, so paths that call it without a separate update (DefineIndex on partitioned tables, AttachPartitionEnsureIndexes) leave partition indexes with relispartition = false. Both the helper's tablecmds.c replacement and the callers' explicit updates are also absent, so attach/detach no longer sets the flag.

Failing oracle case: src/test/regress||foreign_key
