# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 68dfecbef210dc000271553cfcb2342989d4ca0f ("Use generateClonedIndexStmt to propagate CREATE INDEX to partitions."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/indexcmds.c

Failing oracle cases:
- `src/test/regress||alter_table`
