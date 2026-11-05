# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d376ab570ef95f2eae13a77cbd9ba21383f195f7 ("In ExecInitModifyTable, don't scribble on the source plan."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/explain.c, src/backend/executor/nodeModifyTable.c, src/backend/optimizer/plan/setrefs.c

Failing oracle cases:
- `src/test/regress||partition_prune`
