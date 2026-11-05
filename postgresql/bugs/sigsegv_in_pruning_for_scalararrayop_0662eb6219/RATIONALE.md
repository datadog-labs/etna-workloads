# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0662eb6219f1f4bafc1916a0bf2813cdc58e5eca ("Fix SIGSEGV in pruning for ScalarArrayOp with constant-null array."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/partitioning/partprune.c

Failing oracle cases:
- `src/test/regress||partition_prune`
