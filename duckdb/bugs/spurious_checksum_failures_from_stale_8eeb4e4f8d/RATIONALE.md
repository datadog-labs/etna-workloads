# Rationale

Today's code already carries the fix in a different form (the stale handle is protected with
`SetDestroyBufferUpon(EVICTION)` rather than a `disk_load_disabled` flag). I removed both protections.

1. `src/storage/metadata/metadata_manager.cpp`, `MetadataManager::ConvertToTransient`: removed the block
   that locks the old handle and calls `SetDestroyBufferUpon(DestroyBufferUpon::EVICTION)`. This traces to the
   fix's `DisableDiskLoad` hunk. Without it a replaced handle whose buffer was evicted reloads from disk,
   racing the in-place checkpoint rewrite.
2. `src/storage/buffer/block_manager.cpp`, `BlockManager::UnregisterPersistentBlock`: calls
   `UnregisterBlock(id)` instead of `UnregisterExpiredBlock(id)`. This traces to the fix's destructor hunk.
   A dying stale handle now erases the newer handle's registration, and in SingleFileBlockManager it moves the
   id out of free_blocks_in_use.

## etna-check
```
FAIL cpp:test/api/test_metadata_pin_race.cpp::Pinning a replaced metadata block handle does not read from disk
     test_metadata_pin_race.cpp:94 :: !pin.IsValid() false
FAIL cpp:...::A dying stale block handle does not unregister a newer handle
     :128 :: block_manager.FreeBlocks() == free_blocks_before 1 == 0
FAIL cpp:...::Concurrent handle destruction does not drop a newer registration
     :178 :: !registration_lost.load() false
FAIL cpp:...::Stress stale metadata block handle pin against checkpoint rewrite
     :313 :: corruption_count.load() == 0 1 == 0
4 of 4 oracle units fail
```
