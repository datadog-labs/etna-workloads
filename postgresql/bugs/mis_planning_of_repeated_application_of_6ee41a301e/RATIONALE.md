# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6ee41a301e70fc8e4ad383bad22d695f66ccb0ac ("Fix mis-planning of repeated application of a projection."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/createplan.c, src/backend/optimizer/util/pathnode.c

Failing oracle cases:
- `src/test/regress||select_parallel`
