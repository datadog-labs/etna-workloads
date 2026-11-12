# Rationale

File: src/src/storage/storage_manager.cpp, `SingleFileStorageCommitState::RevertCommit()`.

Single hunk changed: removed the loop (added by the fix) that calls `block_manager.MarkBlockAsModified(block_id)` for every block of the
optimistically written row group data. The `storage` member and its constructor init were kept, because today's `FlushCommit()` also uses
`storage`. In the fix those lines were only added for this loop. Without the loop, blocks allocated by a failed commit are orphaned.

Oracle result (etna-check):
FAIL test/sql/storage/optimistic_write/optimistic_write_commit_failure.test:37 (CHECKPOINT)
FATAL Error: Failed to create checkpoint because of error: Block verification failed - blocks "1" were not found as being used OR marked as free
1 of 1 oracle units fail
