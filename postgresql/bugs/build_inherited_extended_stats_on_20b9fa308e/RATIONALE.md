# Rationale

The tree has since gained `stxdinherit`, so the selfuncs/dependencies/mcv hunks of the fix no longer exist in their old form. Only the analyze.c hunk can be re-expressed.

## src/backend/commands/analyze.c, do_analyze_rel()
This traces to the fix hunk that introduced `build_ext_stats`, which is true for `inh` on partitioned tables and for `!inh` otherwise.
Before the fix, extended stats for partitioned tables were never built from the inheritance tree. The change skips `BuildRelationExtStatistics` when `inh` is true and the relation is a partitioned table. As a result, no inherited extended stats exist for partitioned tables, and estimates on them fall back to the non-extended path.

## Failing oracle cases
- src/test/regress||stats_ext
