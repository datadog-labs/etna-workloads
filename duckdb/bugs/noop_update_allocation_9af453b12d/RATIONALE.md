# Rationale

File: src/storage/table/update_segment.cpp, `UpdateSegment::Update`.

Hunks (both trace to the fix's two hunks, reversed):
1. Re-added the string-heap push block (`AddBlob` of all update strings) right after the `count == 0` early return, i.e. *before* the sort/dedup and the `get_effective_updates` no-op filter (reverses the fix's second hunk, which had moved it after).
2. Removed the block from its post-filter position (reverses the fix's added hunk).

Effect: no-op string updates (`SET payload = payload`) copy strings into the segment's string heap even though the update is then discarded, so memory accumulates across checkpoints.

## Oracle result
See etna-check output below.

```
build ok; running oracle tests ...
FAIL     test/sql/storage/update/noop_string_update_memory.test
         Wrong result in query! (test/sql/storage/update/noop_string_update_memory.test:16)!
         SELECT memory_usage_bytes < 32768 FROM duckdb_memory() WHERE tag = 'ALLOCATOR';
         Expected result: true   Actual result: 0
1 of 1 oracle units fail
```
The memory assertion fails: the retained string copies keep ALLOCATOR memory above 32 KiB.
