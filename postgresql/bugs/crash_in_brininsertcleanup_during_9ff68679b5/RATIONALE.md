# Reintroduced bug: crash in brininsertcleanup during logical replication

## Changed hunks
1. `src/backend/access/brin/brin.c`, `brininsertcleanup()` (fix.patch brin.c hunk): restored the old code. It tests `ii_AmCache == NULL` and leaves `ii_AmCache` pointing at the `BrinInsertState`. It then terminates the revmap and sets `bis_rmAccess` and `bis_desc` to NULL instead of clearing `ii_AmCache` and freeing the state. A second cleanup call on the same IndexInfo therefore calls `brinRevmapTerminate(NULL)` and crashes.
2. `src/backend/replication/logical/worker.c`, `apply_handle_insert()` and `apply_handle_insert_internal()` (fix.patch worker.c insert hunks): `apply_handle_insert_internal` once again does `ExecOpenIndices` and `ExecCloseIndices` itself. The caller no longer does. The Asserts are gone.
3. `worker.c`, `apply_handle_delete()` and `apply_handle_delete_internal()` (fix.patch delete hunks): same change. The open and close are back inside the internal function.

When the target is partitioned, `apply_handle_tuple_routing` gets a ResultRelInfo from `ExecFindPartition`, which has already opened the indexes. The internal functions then open and close them a second time, and `ExecCleanupTupleRouting` closes them a third time. With a BRIN index on the subscriber's partitioned table (as in 013_partition.pl), the second cleanup call crashes.

I did not reverse the fix.patch hunks in `apply_handle_tuple_routing` that removed the duplicate open and close calls. Reverting the brin and insert/delete hunks was enough to make the oracle cases fail.

## Failing oracle cases
Most or all of the 74 cases from src/test/subscription t/013_partition.pl now fail, reported as `missing` because the test aborts. They include "check replica insert after trigger applied on subscriber", the "delete from tab1*" and "delete from tab2/tab3" cases, "delete target row is missing in ..." and "initial data synced for ...". I only saw the first 18 lines of the oracle output, so I have not confirmed the exact count.
