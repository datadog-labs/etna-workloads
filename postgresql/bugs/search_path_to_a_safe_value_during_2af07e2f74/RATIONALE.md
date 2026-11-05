# Rationale

Current code wraps the fix's `SetConfigOption("search_path", GUC_SAFE_SEARCH_PATH, ...)` in a helper, `RestrictSearchPath()` (guc.c). I removed the call to it at the same place in four maintenance functions. This reverses the matching fix.patch hunks, which add the search_path restriction right after `NewGUCNestLevel()`:

- src/backend/commands/analyze.c, `do_analyze_rel` (analyze.c hunk)
- src/backend/commands/vacuum.c, `vacuum_rel` (vacuum.c hunk)
- src/backend/commands/cluster.c, `cluster_rel` (cluster.c hunk)
- src/backend/commands/matview.c, `ExecRefreshMatView` (matview.c hunk)

Effect: these operations run as the table owner with the caller's search_path. Expressions in indexes or matviews can then resolve names through an unsafe path.

## Failing oracle cases
- src/test/regress||namespace
- src/test/regress||privileges
