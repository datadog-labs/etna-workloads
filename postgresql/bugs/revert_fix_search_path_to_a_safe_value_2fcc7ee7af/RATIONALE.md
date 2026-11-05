# Rationale
The fix (a revert of "Fix search_path to a safe value during maintenance operations") removed the
`SetConfigOption("search_path", GUC_SAFE_SEARCH_PATH, ...)` call after each `NewGUCNestLevel()` in
maintenance code run as the table owner. In current code that call is the helper `RestrictSearchPath()`
(guc.c). I removed the calls at the sites the patch touched:

- access/brin/brin.c `brin_summarize_range` (brin.c hunk)
- catalog/index.c `index_concurrently_build`, `index_build`, `validate_index`, `reindex_index` (index.c hunks)
- commands/analyze.c `do_analyze_rel`, commands/cluster.c `cluster_rel`, commands/matview.c `ExecRefreshMatView`, commands/vacuum.c `vacuum_rel` (respective hunks)
- commands/indexcmds.c `DefineIndex` (root and child), `ReindexRelationConcurrently` (indexcmds.c hunks)

Effect: maintenance operations run with the caller's search_path, so user-defined functions in
index expressions, etc. can again be resolved through an unsafe path (the bug).
Later-added call sites (indexcmds.c ddl_save_nestlevel ones, the second root call, amcheck) and the
helper/macro itself are left in place since they aren't in the patch.

Failing oracle cases: src/test/modules/test_oat_hooks (test_oat_hooks), src/test/regress privileges.
