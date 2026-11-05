# Rationale

The current code has been restructured: set_append_rel_pathlist is now add_paths_to_append_rel and already tolerates children with no unparameterized path. Reversing the whole fix therefore does not apply, and removing only the lateral propagation does not fail the oracle. I made two changes.

1. `src/backend/optimizer/prep/prepjointree.c`, `pull_up_simple_union_all()`
   - Traces to the fix.patch prepjointree.c hunk.
   - I removed the block that copies `rte->lateral` to the pulled-up child RTEs, so the children are no longer marked LATERAL.

2. `src/backend/optimizer/path/allpaths.c`, `add_paths_to_append_rel()`
   - Traces to the fix.patch allpaths.c hunk in `set_append_rel_pathlist`. That hunk removed the `elog(ERROR, "LATERAL within an append relation is not supported yet")` and replaced it with the `subpaths_valid = false` handling.
   - When a child has no unparameterized cheapest path, the code now raises that error instead of setting `subpaths_valid = false`. A `LATERAL (SELECT ... UNION ALL SELECT ...)` query therefore errors out instead of being planned with parameterized Append paths.

Failing oracle case: `src/test/regress||join`. This is the "lateral with UNION ALL subselect" test.
