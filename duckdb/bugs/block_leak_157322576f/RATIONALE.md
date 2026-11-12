# Rationale

File: src/src/storage/wal_replay.cpp

1. `WriteAheadLogDeserializer::ReplayRowGroupData` (DeserializeOnly branch): instead of recording block ids in
   `state.row_group_blocks`, call `block_manager.MarkBlockAsUsed(block_id)` immediately during the deserialize-only
   scan. Traces to the fix's hunk in the same function.
2. `WriteAheadLogReplayer::ReplayLog`: removed the loop marking `checkpoint_state.row_group_blocks` as used after the
   decision to replay (fix's hunk adding that loop). Marks now happen even when the WAL is discarded because its
   checkpoint completed, so they leak, and the blocks are never freed.

The `row_group_blocks` member (fix hunk 1) is left in place: today's code also uses it for discarding uncommitted
transactions' blocks; it is simply no longer populated, so that resize is a no-op.

## Oracle result
See etna-check output below (filled in after run).

```
FAIL     test/sql/storage/wal/wal_replay_clean_checkpoint_block_marks.test_slow
         ...test_slow:58 :: Query unexpectedly failed!  CHECKPOINT;
         FATAL Error: Failed to create checkpoint because of error: Block verification failed - blocks "0, 1, 2, ...
1 of 1 oracle units fail
```
