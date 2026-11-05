# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 382ce9cb717f3376174f852e8f4b8c28b1c87020 ("Fix planner error with SRFs and grouping sets"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/planner.c, src/backend/optimizer/util/tlist.c, src/include/optimizer/tlist.h

Failing oracle cases:
- `src/test/regress||groupingsets`
