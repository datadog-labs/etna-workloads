# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 75dfde13639a57513e23e58c961a69c5bbf017b6 ("Fix an oversight in cbc127917 to handle MERGE correctly"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c, src/include/nodes/execnodes.h

Failing oracle cases:
- `src/test/regress||partition_prune`
