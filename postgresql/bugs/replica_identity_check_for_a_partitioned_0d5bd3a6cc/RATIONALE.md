# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0d5bd3a6cc3e4cd2fb44e2714e52a684cc7bbc25 ("Fix replica identity check for a partitioned table."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execReplication.c

Failing oracle cases:
- `src/test/regress||publication`
