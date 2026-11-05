# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bdc5dedfcaa57ddeef115252283019d79083d8a2 ("Fix buggy interaction between array subscripts and subplan params"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execExpr.c, src/backend/executor/execExprInterp.c

Failing oracle cases:
- `src/test/regress||subselect`
