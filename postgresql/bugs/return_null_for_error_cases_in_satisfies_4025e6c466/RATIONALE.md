# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4025e6c46620048804467d2ad29d31aa9ba50387 ("Do not return NULL for error cases in satisfies_hash_partition()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/partitioning/partbounds.c

Failing oracle cases:
- `src/test/regress||hash_part`
