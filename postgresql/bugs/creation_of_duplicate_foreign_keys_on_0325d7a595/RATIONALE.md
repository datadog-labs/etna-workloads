# Rationale

File/function: src/backend/commands/tablecmds.c, addFkRecurseReferencing (the partitioned-table branch).

Traces to the fix.patch hunk in ATAddForeignKeyConstraint. The fix replaced a separate per-partition
creation path with the FK-cloning code, which reuses existing equivalent constraints. In today's code
that de-duplication is the loop over RelationGetFKeyList(partition) calling tryAttachPartitionForeignKey.
I removed that loop. Every partition now gets a new FK constraint through addFkConstraint, even when an
equivalent one already exists. That brings back the duplicate foreign keys on partitions.

Failing oracle case: src/test/regress||foreign_key
