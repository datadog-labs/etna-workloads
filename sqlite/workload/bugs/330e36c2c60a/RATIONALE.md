# Rationale

Only the incremental-merge hunks of the fix are reversible in 3.54.1; the
tombstone-rebuild (MINSLOT/nSlot) and fts5_structure npgtombstone hunks are
already present and are left untouched (the latter is only a test-visibility
column, not the bug).

Changes in `ext/fts5/fts5_index.c`:

1. `fts5IndexMerge()`: removed `if( nMin==1 ) nMin = 2;` at the end of the
   merge loop (fix hunk 1 added it). Without it nMin is never raised after the
   first iteration.
2. `sqlite3Fts5IndexMerge()`: in the `nMerge<0` (incremental optimize) branch,
   `nMin = 1` restored to `nMin = 2` (fix hunk 2). With nMin=2 a lone segment
   that has tombstone hash pages is never selected for merging, so the
   incremental optimize cannot rewrite a single-segment index with tombstones.

The surrounding 3.54.1 code differs only by the SMALLEST_INT32 handling of
nMerge, which is unrelated.

## Oracle failures
fts5contentless3-3.4 (count 203 instead of 197), 3.5 (203 vs 200),
3.6 (structure level 0 instead of 1; npgtombstone 3), 3.7 (still `0 0 3`
instead of `2 0 0`): the incremental `merge, -N` never rewrites the single
segment with tombstones, so tombstones are not purged.
