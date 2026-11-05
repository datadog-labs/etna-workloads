# Rationale

Bug: in prepared query mode, pgbench prepared statements inside a pipeline, after `\startpipeline`. Prepares therefore ran in pipeline mode, not before it.

## Hunks (src/bin/pgbench/pgbench.c)

1. `executeMetaCommand` (META_STARTPIPELINE): removed the `if (querymode == QUERY_PREPARED) prepareCommandsInPipeline(st);` call. This traces to the fix.patch hunk that added that call. Without it, commands in a pipeline are no longer prepared in advance.
2. `prepareCommand`: when the connection is in pipeline mode, use `PQsendPrepare` (asynchronous). Otherwise use `PQprepare`. This traces to the fix.patch hunk that removed the old inline prepare code from `sendCommand`, which had the same two branches. The prepare is now sent inside the pipeline, so it can acquire a snapshot there. That makes `BEGIN ISOLATION LEVEL SERIALIZABLE` inside a pipeline fail, as it did before the fix.
3. `sendCommand` (QUERY_PREPARED branch): replaced `prepareCommand(st, st->command)` with a loop that prepares every command of the script on first use. This traces to the fix.patch hunk that removed the old "prepare all commands of the script" block. Combined with 1 and 2, all prepares are queued inside the pipeline before the first command (BEGIN ISOLATION LEVEL SERIALIZABLE) runs. A snapshot is taken first, so the serializable transaction fails. With only edits 1 and 2, the oracle still passed.

## Oracle results
3 of 465 cases fail:
- `001_pgbench_with_server.pl|working \startpipeline with serializable status (got 0 vs expected 0)`
- `001_pgbench_with_server.pl|working \startpipeline with serializable stdout /(?^:actually processed: (\d+)/\1)/`
- `001_pgbench_with_server.pl|transaction count for <P>/001_pgbench_log_3.<N> (10)`
