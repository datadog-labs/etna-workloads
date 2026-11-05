# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cbb9086c9ef64b020cb9036f50afc14644bbf734 ("Fix bug in cbc127917 to handle nested Append correctly"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execPartition.c, src/backend/partitioning/partprune.c

Failing oracle cases:
- `src/test/regress||partition_prune`
