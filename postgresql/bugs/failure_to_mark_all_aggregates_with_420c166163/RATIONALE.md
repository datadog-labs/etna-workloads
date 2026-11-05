# Rationale

Changed file: src/backend/optimizer/plan/planner.c

1. `grouping_planner`: removed the early `preprocess_aggrefs()` calls on `processed_tlist` and `havingQual`. These are the modern equivalent of fix.patch's block that collects agg costs and marks aggtranstypes before the tlist is split into pathtargets.
2. `create_grouping_paths`: marking now happens here, on `target->exprs` and `havingQual`. This matches the pre-fix location, where `get_agg_clause_costs` ran on `target->exprs`. It runs after the tlist has been sliced into pathtargets, so some copies of Aggref nodes (for example in other pathtargets such as a LIMIT or sort target) can escape being marked with the resolved aggtranstype.

Failing oracle case: src/test/regress||limit
