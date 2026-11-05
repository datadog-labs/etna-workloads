# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4d346def1555ea55b3adf76fc4afa3d3495ecfdd ("Avoid pushing quals down into sub-queries that have grouping sets."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/allpaths.c

Failing oracle cases:
- `src/test/regress||groupingsets`
