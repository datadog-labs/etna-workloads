# Rationale
File: src/backend/catalog/index.c, function index_concurrently_swap (both hunks trace to the index_concurrently_swap hunks of fix_impl.patch).

1. Removed the swap of `relispartition` between old and new index (fix hunk "Copy partition flag to track inheritance properly"). Without it, the new index is not marked as a partition after REINDEX CONCURRENTLY.
2. Removed the "Swap inheritance relationship with parent index" block (DeleteInheritsTuple/StoreSingleInheritance; fix hunk of the same name). The pg_inherits entry stays on the old index, so the partition index loses its link to the parent index.

The dependency swapping already exists in today's code and was left as is.

Failing oracle case: src/test/regress||create_index
