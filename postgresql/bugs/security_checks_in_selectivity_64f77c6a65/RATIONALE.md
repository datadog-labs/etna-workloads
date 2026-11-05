# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 64f77c6a65cb6a0731e59acbfab1dd1663b1cdd3 ("Fix security checks in selectivity estimation functions."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/execMain.c, src/backend/optimizer/plan/planner.c, src/backend/statistics/extended_stats.c, src/backend/utils/adt/selfuncs.c, src/include/executor/executor.h, src/include/utils/selfuncs.h

Failing oracle cases:
- `src/test/regress||privileges`
- `src/test/regress||rowsecurity`
- `src/test/regress||stats_ext`
