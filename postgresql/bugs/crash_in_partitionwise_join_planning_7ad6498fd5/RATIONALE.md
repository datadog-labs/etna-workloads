# Rationale

All changes are in `src/backend/optimizer/path/joinrels.c`, function `try_partitionwise_join` and its helpers. They trace to the joinrels.c hunks of fix_impl.patch.

1. **Includes and prototype** (`nodeFuncs.h`, `clauses.h`, the `update_child_rel_info` prototype). These trace to the include and prototype hunks. They are needed to bring the helper back.
2. **`update_child_rel_info()` restored.** This traces to the hunk where the fix deleted the function. The helper builds child tlist expressions and EC members for a dummy child lazily, in the middle of join planning. Under GEQO that runs in a short-lived memory context, so the data it builds can be freed while it is still referenced. That is the crash.
3. **Per-child loop in `try_partitionwise_join`.** This traces to the big hunk. I removed the `rel1_empty`/`rel2_empty` computation, the join-type switch that skips empty segments, and the NULL (pruned child) rejection. For a dummy leaf child lacking `consider_partitionwise_join`, the code calls `update_child_rel_info` and sets the flag. The fix instead sets `joinrel->nparts = 0` and returns.

Pruned (NULL) children are no longer handled, and dummy children are joined after lazy setup. This brings back the crash and the wrong-plan behaviour.

I did not change the planner.c and allpaths.c hunks. The current code has evolved around live_parts, and the joinrels.c change was enough to reproduce the failure.

Failing oracle cases (both fail, as the oracle output shows):
- src/test/regress||partition_aggregate
- src/test/regress||partition_join
