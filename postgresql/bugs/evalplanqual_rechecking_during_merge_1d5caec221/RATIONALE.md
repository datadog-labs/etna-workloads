# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1d5caec221d85b8950a1ee3d8bb6fad262549ea6 ("Fix EvalPlanQual rechecking during MERGE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c, src/backend/optimizer/plan/planner.c, src/include/nodes/execnodes.h, src/include/nodes/plannodes.h

Failing oracle cases:
- `src/test/isolation||merge-join`
- `src/test/regress||merge`
- `src/test/regress||with`
