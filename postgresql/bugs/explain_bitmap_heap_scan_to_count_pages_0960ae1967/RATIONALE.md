# Rationale

File/function: src/backend/access/heap/heapam_handler.c, BitmapHeapScanNextBlock (the page counting moved here from nodeBitmapHeapscan.c's BitmapHeapNext since the fix).

Traces to the fix hunks in BitmapHeapNext that moved the exact_pages/lossy_pages increment to before the "skip fetching / no visible tuples" `continue`. Here the counters are now incremented only when the page has visible tuples (`ntup > 0`), so pages with no visible tuples are not counted in EXPLAIN's "Heap Blocks: exact/lossy" output, which is the original bug.

Failing oracle case: src/test/regress||partition_prune
