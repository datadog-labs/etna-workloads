# Rationale

File: src/backend/storage/freespace/freespace.c

1. `RecordAndGetPageWithFreeSpace()` - traces to the fix hunk that adds the `fsm_does_block_exist()` check on `search_slot`. The block is returned without checking it exists, so an FSM pointing past the end of the main fork hands out nonexistent blocks.
2. `fsm_search()` - traces to the hunk that keeps the pin, checks `fsm_does_block_exist()` at the bottom level, zeroes the bad slot and restarts. Reverted to plain `return fsm_get_heap_blk()` with the original unlock/release.

The `fsm_does_block_exist()` helper stays defined but unused. Comment-only hunks were not touched.

Expected failing oracle case: src/test/recovery|t/008_fsm_truncation.pl|INSERT succeeds with truncated relation FSM

3. `FreeSpaceMapPrepareTruncateRel()` - traces to the truncation hunk (dirty/WAL-log comment rewrite) and the README hint-vs-MarkBufferDirty hunk. The fix made the truncation-time slot clearing "non-critical" because readers now check block existence. Reverting only the readers did not fail the oracle test, since the standby still cleared the slots during replay. I removed the WAL-log call, went back to `MarkBufferDirtyHint()`, and skipped the slot zeroing during recovery. The standby then keeps FSM slots for truncated blocks. With the checks from hunks 1-2 gone, `GetPageWithFreeSpace` returns blocks past the end of the main fork.

This hunk is a looser adaptation than hunks 1-2. A version that only dropped the log call or the full dirtying still passed the oracle, so the recovery-skip was needed to make it fail.

Result: the oracle case fails (1/1).
