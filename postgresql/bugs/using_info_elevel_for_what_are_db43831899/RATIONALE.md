Reverted the DEBUG1 -> INFO change (4 one-line hunks, each tracing to fix_impl.patch):
- src/backend/commands/tablecmds.c, QueuePartitionConstraintValidation: two ereport(DEBUG1) -> ereport(INFO) ("partition constraint ... implied by existing constraints" and the default-partition variant). Traces to the tablecmds.c hunk.
- src/backend/partitioning/partbounds.c, check_default_partition_contents: two ereport(DEBUG1) -> ereport(INFO). Traces to the two partbounds.c hunks.
Debug messages are again sent to clients at INFO level, so regression output contains extra INFO lines.

Failing oracle cases: src/test/regress alter_table, create_table.
