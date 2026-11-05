# Rationale
Hunk: src/backend/commands/tablecmds.c, RemoveInheritance(). Traces to the fix.patch hunk that passes `child_dependency_type(child_is_partition)` to drop_parent_dependency(). In current code the variable is `is_partitioning`. The reverted code always passes DEPENDENCY_NORMAL, so drop_parent_dependency() never deletes the DEPENDENCY_AUTO pg_depend entry of a detached partition. The stale dependency remains after DETACH PARTITION.

Failing oracle case: src/test/regress||alter_table
