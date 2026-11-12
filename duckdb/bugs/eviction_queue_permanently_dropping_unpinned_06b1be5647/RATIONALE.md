# Rationale

Hunk: `src/storage/buffer/buffer_pool.cpp`, `EvictionQueue::IterateUnloadableBlocks`.
Traces to the fix's buffer_pool.cpp hunk. The `NO_TEMP_DIRECTORY` case no longer re-enqueues the node
(and no longer restores the live-queue-entry flag). It now falls into the `continue` branch together with
PINNED/ALREADY_UNLOADED, so an unpinned block that cannot be offloaded for lack of a temp directory is
dropped from the eviction queue permanently. This is the pre-fix behaviour (the old `!CanUnload()` -> `continue`).
The enum and CanUnload() refactor are kept unchanged to avoid a header rebuild; behaviour is equivalent to the old bool.

## Oracle
```
FAIL     test/sql/storage/evict_unpinned_without_temp_directory.test
         Query unexpectedly failed! (test/sql/storage/evict_unpinned_without_temp_directory.test:32)!
         Out of Memory Error: Failed to change memory limit to 10000000: could not free up enough memory for the new limit
1 of 1 oracle units fail
```
After temp_directory is set, the blocks are no longer in the queue, so the second `SET max_memory = '10MB'` fails.
