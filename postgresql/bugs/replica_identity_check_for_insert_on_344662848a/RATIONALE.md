# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 344662848ac15efc89e09b7d39662d7c71b30e06 ("Fix replica identity check for INSERT ON CONFLICT DO UPDATE."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/copyfrom.c, src/backend/executor/execMain.c, src/backend/executor/execPartition.c, src/backend/executor/nodeModifyTable.c, src/include/executor/executor.h

Failing oracle cases:
- `src/test/regress||publication`
