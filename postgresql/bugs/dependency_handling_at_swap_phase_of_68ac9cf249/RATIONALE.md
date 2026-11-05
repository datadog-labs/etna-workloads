# Rationale

## Changed hunk
- File: `src/backend/catalog/index.c`, function `index_concurrently_swap()`.
- Traces to the single hunk of fix_impl.patch (the same place, the dependency move at the swap phase).
- The fix added `deleteDependencyRecordsFor(RelationRelationId, newIndexId, false)` before moving the dependencies from the old index to the new one. That gave the new index a clean starting state.
- In REL_18_6 the code no longer does that. It swaps the dependencies in both directions: new->old, then old->new. The swap gives the same clean state without the delete call.
- I removed the first pair of calls, `changeDependenciesOf/On(new, old)`. What remains is the pre-fix behaviour: the old index's dependencies are moved onto the new index, and the dependencies the new index already had from `index_create` are neither deleted nor moved away.
- That leaves duplicate or stale pg_depend entries on the new index. This is the bug the fix removed.

## Failing oracle cases
- `src/test/regress||create_index`
