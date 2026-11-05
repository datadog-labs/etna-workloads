# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7c872849407730fa01e2c13b2d47483bc3ff6e7e ("Fix failure for generated column with a not-null domain constraint."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c, src/backend/optimizer/prep/preptlist.c

Failing oracle cases:
- `src/test/regress||generated_stored`
