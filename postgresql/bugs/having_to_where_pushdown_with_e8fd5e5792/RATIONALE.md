# Rationale

Hunk: src/backend/optimizer/plan/planner.c, subquery_planner(), HAVING-to-WHERE loop.
Traces to the fix.patch hunk that added `bms_is_member(havingIdx, havingCollationConflicts) ||`
to the "keep it in HAVING" condition. The conflict detection has since been refactored
(find_having_conflicts / expression_has_grouping_conflict, also covering opfamily conflicts),
so I removed the equivalent check `bms_is_member(havingIdx, havingPushdownConflicts) ||`.
Result: HAVING clauses whose collation differs from a nondeterministic GROUP BY collation are
again pushed to WHERE, filtering rows before grouping and changing aggregate results.

Failing oracle case: src/test/regress||collate.icu.utf8
