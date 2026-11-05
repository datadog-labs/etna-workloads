Hunk: src/backend/access/heap/heapam.c, ReleaseBulkInsertStatePin() — removed the reset of bistate->next_free/last_free (reverse of the sole fix_impl.patch hunk). With stale bulk-extension state kept when COPY switches partitions, a later partition may look for free pages from another relation's extension, causing errors.

Failing oracle case: src/test/regress||copy
