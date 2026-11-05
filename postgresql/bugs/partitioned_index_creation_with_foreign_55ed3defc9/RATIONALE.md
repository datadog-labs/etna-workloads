# Rationale

Changed hunk: `src/backend/commands/indexcmds.c`, `DefineIndex()`. It traces to the `indexcmds.c` hunk of fix_impl.patch.

I removed the block in the partition-recursion loop that skips foreign-table children. For a unique or primary key index, that block raised an error. Without it, `DefineIndex` tries to create an index on the foreign partition. The result is a wrong error, "cannot create index on foreign table", where a regular index should have been skipped and a unique index rejected with the intended message. The `tablecmds.c` and `utility.c` hunks were not reverted.

Failing oracle case: `src/test/regress||foreign_data`.
