# Rationale

## src/backend/catalog/heap.c, StorePartitionKey()
Traces to the heap.c hunk of fix_impl.patch (the new loop that records
DEPENDENCY_INTERNAL dependencies of each plain partition-key column on the table).
I removed that loop. Without it, plain partition key columns have no dependency on
the table, so the catalog no longer protects them from being dropped (the bug the
fix addressed). The expression-column dependencies are left as in the current code.

## Failing oracle cases
- src/test/regress||alter_table
- src/test/regress||create_table
