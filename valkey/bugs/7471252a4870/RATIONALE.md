# Rationale

The bug: with dual-channel replication, the RDB snapshot is written by the child straight to the replica's socket, so `total_net_repl_output_bytes` never counted those bytes.

## Change

`src/rdb.c`, `saveSnapshotToConnectionSockets()`: removed the block that sent `CHILD_INFO_TYPE_REPL_OUTPUT_BYTES` (with `rdb.processed_bytes`) to the parent after a successful snapshot. This reverses the fix's `rdb.c` hunk. In 9.0.7 the condition is `if (dual_channel)` rather than `if (!options.use_pipe)`, but it is the same code path.

I left the plumbing from the other hunks in place (the `repl_output_bytes` field in childinfo.c, the enum value, the changed signatures). Without the sender it is dead code, so the pre-fix behaviour is restored: the parent never receives the byte count.

## Oracle cases that fail

- `Dual-channel replication counts snapshot bytes`
- `dual-channel replication reports rdb transfer bytes`

Both fail with "Replication output bytes not updated", because `total_net_repl_output_bytes` stays 0 after a dual-channel full sync. The other 39 cases pass.
