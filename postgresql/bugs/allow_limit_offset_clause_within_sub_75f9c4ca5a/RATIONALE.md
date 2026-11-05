# Rationale

Hunk: src/backend/optimizer/path/allpaths.c, set_rel_consider_parallel(), case RTE_SUBQUERY.
Traces to the allpaths.c hunk of fix_impl.patch. I removed the `limit_needed(subquery)` check
that returned early (leaving consider_parallel false). Subqueries with LIMIT/OFFSET can then
be pushed to parallel workers again, which gives inconsistent results.
The planner.c/planner.h hunks only export limit_needed(). In current code it is already
exported, so I left them alone.

Failing oracle case: src/test/regress||select_parallel
