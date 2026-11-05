# Rationale

Changed hunk: `src/backend/commands/tablecmds.c`, `transformPartitionSpec()`.

Traces to the fix.patch hunk in tablecmds.c that adds "Check valid number of columns for strategy". In the original commit, that check replaced the one in parse_utilcmd.c (`cannot list partition using more than one column`). The old check no longer exists in today's code, so I removed the check from its current location.

Effect: `CREATE TABLE ... PARTITION BY LIST (a, b)` is no longer rejected. This is the validation gap the fix closed.

Failing oracle case: `src/test/regress||create_table`.
