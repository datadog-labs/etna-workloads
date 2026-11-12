# Rationale

v2.0.0 already contains the version-manager fix (duckdb/duckdb#25970: a checkpoint ignores deletes committed above its
visibility bound), not the 1.5 backport's code. So the backport's hunks (RowGroupCollection::Checkpoint calling
GetPersistedDeletePointers, the new RowGroup method, the removed assert) cannot be reverted literally. I re-introduced the
bug at the equivalent place instead.

## Hunk: src/storage/table/row_version_manager.cpp, RowVersionManager::Checkpoint
Traces to the fix's goal: an unchanged table's checkpoint must not serialize deletes that committed above its bound.
The early-return condition was
`!oldest.IsValid() || oldest >= visibility_bound`; it is now `!oldest.IsValid()`.
A delete committed above the bound (during the checkpoint) therefore makes Checkpoint rewrite the version info and
drop the old `storage_pointers`, without marking the old blocks in use. The reused table metadata still references
those blocks, so the checkpoint frees them and a later WAL replay fails.

## Oracle result
```
FAIL     test/sql/storage/concurrent_checkpoint_unchanged_table_delete_blocks.test_slow
         ...test_slow:105 :: Query failed with internal exception!
         ATTACH '...unchanged_table_delete_blocks.db' AS db;
         INTERNAL Error: Failure while replaying WAL file ...
1 of 1 oracle units fail
```
