# Rationale

- File/function: src/backend/catalog/index.c, index_concurrently_swap().
- Traces to the fix.patch hunk in index.c that added `CopyStatistics(oldIndexId, newIndexId);` at the end of index_concurrently_swap. I removed that call. CopyStatistics() already exists in heap.c and heap.h, so the heap.c/heap.h hunks stay untouched. They only define the function, and without the call it is unused.
- Why this brings the bug back: REINDEX CONCURRENTLY builds a new index and swaps it in for the old one. The old index's pg_statistic rows, which hold expression-index stats, are no longer copied to the new index, so they are lost.

Failing oracle case: src/test/regress||create_index
