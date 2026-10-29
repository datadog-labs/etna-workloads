# Rationale

Both changes are in `ext/fts5/fts5_storage.c`, `fts5StorageDeleteFromIndex()`. They reverse the two hunks the fix added to that function. The `fts5_expr.c` hunk is an unrelated NULL-guard and was left alone.

1. Removed the `aTotalSize[iCol-1]<0 => FTS5_CORRUPT` check after the per-column decrement. In 3.54.1 it is guarded by `rc==SQLITE_OK` and sits inside the locale block. Without it, a 'delete' with bogus data drives the column totals negative without being noticed.
2. Restored the unconditional `p->nTotalRow--;`. This replaces the `if( rc==SQLITE_OK && p->nTotalRow<1 ) rc = FTS5_CORRUPT; else nTotalRow--;` check, so a 'delete' on an empty or over-deleted table no longer reports corruption.

## Failing oracle cases
- fts5delete-2.1: expected `database disk image is malformed`, but the delete of a nonexistent row now succeeds.
- fts5delete-2.2: the repeated 'delete' no longer reports corruption. It got `0 {}`.
