# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 02e69be47c05c10c8ee8ac5d7634a4048c037ebc ("Fix issue with RANGE's DEFAULT partition pruning"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/partitioning/partprune.c

Failing oracle cases:
- `src/test/regress||partition_prune`
