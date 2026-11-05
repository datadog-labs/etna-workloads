# Rationale
Fix: is_alter_table was passed as true when DefineIndex is called to create a PK index in a partition (attach path and recursion to children), so index_check_primary_key rejects a second PK. Today the same effect also comes from `relispartition` in index_check_primary_key, which masks reverting the flag hunks alone.

1. src/backend/commands/tablecmds.c, AttachPartitionEnsureIndexes: DefineIndex's is_alter_table `true` -> `false` (fix hunk in tablecmds.c).
2. src/backend/commands/indexcmds.c, DefineIndex, recursion to children: `is_alter_table` -> `false` (fix hunk in indexcmds.c).
3. src/backend/catalog/index.c, index_check_primary_key: condition `(is_alter_table || relispartition)` -> `is_alter_table`, removing the later-added check that independently covers the fix's purpose; without it, the reverted flags again allow two PKs in a partition.

Failing oracle case: src/test/regress||indexing
