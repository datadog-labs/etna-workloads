# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 27c7c11366f72b1933e298481954a24c742036de ("Fix concurrent update trigger issues with MERGE in a CTE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c, src/backend/executor/execReplication.c, src/backend/executor/nodeModifyTable.c, src/include/commands/trigger.h

Failing oracle cases:
- `src/test/isolation||merge-match-recheck`
