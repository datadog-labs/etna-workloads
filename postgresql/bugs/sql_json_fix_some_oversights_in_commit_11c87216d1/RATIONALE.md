# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 11c87216d134a606938531e52edab6189bce6c2d ("SQL/JSON: Fix some oversights in commit b6e1157e7"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execExpr.c, src/backend/optimizer/util/clauses.c, src/include/nodes/primnodes.h

Failing oracle cases:
- `src/test/regress||sqljson`
