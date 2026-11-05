# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d57534740b7682c2816ce6c54318521787fcfacf ("Fix EXPLAIN of SEARCH BREADTH FIRST with a constant initial value."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c, src/backend/utils/fmgr/funcapi.c

Failing oracle cases:
- `src/test/regress||with`
