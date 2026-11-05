# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2ab6d28d233af17987ea323e3235b2bda89b4f2e ("Fix crash with pg_partition_root"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/partitionfuncs.c

Failing oracle cases:
- `src/test/regress||partition_info`
