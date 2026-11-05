# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 581df2148737fdb0ba6f2d8fda5ceb9d1e6302e6 ("Fix rowcount estimate for gather (merge) paths"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/allpaths.c, src/backend/optimizer/path/costsize.c, src/backend/optimizer/plan/planner.c, src/backend/optimizer/util/pathnode.c, src/include/optimizer/cost.h

Failing oracle cases:
- `src/test/regress||join_hash`
