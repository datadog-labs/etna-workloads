# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d9e46dfb78abf4d3be6071b8c4495df9e1bb4706 ("Fix runtime partition pruning for HASH partitioned tables"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execPartition.c

Failing oracle cases:
- `src/test/regress||partition_prune`
