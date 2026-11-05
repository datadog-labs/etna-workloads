# Rationale
File: src/backend/statistics/extended_stats.c, function statext_mcv_clauselist_selectivity (loop over clauses), tracing to the fix.patch hunk at @@ -1758,39 +1762,65 @@.

The fix skips clauses with neither attnums nor expressions (incompatible or already estimated). I restored the old logic: the only filter is `!bms_is_member(listidx, *estimatedclauses)` plus subset/covers checks. Both checks return true for empty attnums/exprs. Incompatible clauses are therefore wrongly treated as covered by the statistics object, added to stat_clauses and marked estimated.

The comment-only hunk in choose_best_statistics and the Assert hunks in mcv.c were not reverted: the comment has no effect on behavior, and the Asserts only add checks.

Failing oracle case: src/test/regress||stats_ext
