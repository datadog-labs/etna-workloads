# Rationale

## src/backend/optimizer/plan/planner.c, make_window_input_target()
Traces to the fix.patch hunk in make_windowInputTargetList that adds
"Add in sortgroupref numbers of GROUP BY clauses, too". I removed the loop
over root->processed_groupClause that added GROUP BY sortgrouprefs to `sgrefs`.
Without it, GROUP BY expressions that are not window clauses get flattened
into their component Vars/Aggs below the WindowAgg, so with window function +
aggregate + GROUP BY expression the upper tlist references Vars that are no
longer available (wrong plan / error).

## Failing oracle cases
src/test/regress||window
