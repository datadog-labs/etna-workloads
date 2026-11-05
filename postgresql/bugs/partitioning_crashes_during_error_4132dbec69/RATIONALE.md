# Rationale
All four hunks are in src/backend/executor/execMain.c and trace to the four hunks of fix_impl.patch.
The original fix added ExecSetSlotDescriptor(slot, tupdesc) after converting the tuple back to the root rowtype. Current code builds a new virtual slot with the root tupdesc via execute_attr_map_slot. The bug is re-expressed by dropping that conversion, so the slot keeps the partition's layout while tupdesc is the root's. The error message then reads the tuple with the wrong descriptor.
- ExecPartitionCheck -> hunk 1
- ExecConstraints (not-null) -> hunk 2
- ExecConstraints (check constraint) -> hunk 3
- ExecWithCheckOptions -> hunk 4

Failing oracle cases: src/test/regress||insert and src/test/regress||updatable_views (both fail with the change).
