# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8b6a0e2392b9fc3f9b821da705797bb54c982dc1 ("Fix MERGE with DO NOTHING actions into a partitioned table."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execPartition.c, src/backend/executor/nodeModifyTable.c

Failing oracle cases:
- `src/test/regress||merge`
