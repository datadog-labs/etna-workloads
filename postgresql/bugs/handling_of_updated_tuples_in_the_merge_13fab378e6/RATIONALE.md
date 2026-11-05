# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 13fab378e630f73b7bb821a211f10b66bc696525 ("Fix handling of updated tuples in the MERGE statement"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c

Failing oracle cases:
- `src/test/isolation||merge-update`
