# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0c06ebf126a0d5df39d9c4298193d9887443ce93 ("Prevent satisfies_hash_partition from crashing with VARIADIC NULL."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/partitioning/partbounds.c

Failing oracle cases:
- `src/test/regress||hash_part`
