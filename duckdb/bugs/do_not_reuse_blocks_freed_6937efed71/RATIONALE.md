# Rationale

File: src/src/storage/single_file_block_manager.cpp, function SingleFileBlockManager::WriteHeader (reverse of the fix's three hunks):

1. Replaced the `checkpoint_freed_blocks` copy with a loop over `modified_blocks` that calls `AddFreeBlock(lock, block)` and collects `fully_freed_blocks`. This puts the checkpoint's freed blocks into free_list before the header is durable, while the lock is held.
2. Re-added `modified_blocks.clear();` after the newly_used_blocks loop.
3. Removed the post-`handle->Sync()` block that took the lock again, erased from `modified_blocks` and called `AddFreeBlock`. `TrimFreeBlocks(fully_freed_blocks)` stays.

So the lock is released with the freed blocks already allocatable. A concurrent optimistic write can overwrite a block the on-disk header still references.

## Oracle result
```
FAIL     test/sql/storage/metadata_reuse_optimistic_write.test_slow
         Error message: Serialization Error: Failed to deserialize: field id mismatch, expected: 101, got: 14234
1 of 1 oracle units fail
exit 0
```
The reopen fails on a block that was overwritten with row data. The error text differs from the upstream IO Error, but the cause is the same.
