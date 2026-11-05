# Rationale

All changes are in src/backend/statistics/extended_stats.c.

## 1. choose_best_statistics
Traces to the fix.patch hunk that replaces `matched = bms_intersect(attnums, info->keys)` with a
per-clause loop counting only clauses fully covered by the object (`bms_is_subset(clause_attnums[i], info->keys)`).
The reverted code drops the subset check for attnums and instead adds
`bms_intersect(clause_attnums[i], info->keys)`. Clauses only partly covered by a statistics
object are counted as matched, so the choice of object is not based on clauses it fully covers.

## 2. statext_mcv_clauselist_selectivity
Traces to the fix.patch hunk that removed
`if (bms_membership(clauses_attnums) != BMS_MULTIPLE) return 1.0;`.
The check is restored (adapted to the current code: `clauses_attnums` is accumulated from the
per-clause attnums, and it returns `sel`). A single multi-column clause, such as an OR over
several columns, is therefore never estimated with the MCV list. This is the case the fix enabled.

## Failing oracle case
src/test/regress||stats_ext
