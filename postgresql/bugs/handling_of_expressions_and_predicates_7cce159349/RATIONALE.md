# Rationale

## src/backend/catalog/index.c, index_concurrently_create_copy()

Traces to the index.c hunk of fix_impl.patch ("Fetch the list of expressions
and predicates directly from the catalogs").

The fix reads indexprs/indpred from pg_index with stringToNode() (and converts
the predicate to implicit-AND form) because the old index's IndexInfo holds
expressions and predicates that were already flattened for the planner. The
bug is back because the code now reuses `oldInfo->ii_Expressions` and
`oldInfo->ii_Predicate` for the new index's IndexInfo. REINDEX CONCURRENTLY
therefore creates the copy from the flattened (planner-processed) trees, not
the original catalog trees, so the new index gets wrong expressions or
predicates.

The rest of the fix (the makeIndexInfo() refactor) is a refactoring and is
left as it is.

## Failing oracle cases

- src/test/regress||create_index (expected; see the oracle run below)
