# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cc733ed164c5b57fdf34d16e4cc8e9bbdc171699 ("Avoid bogus scans of partitions when validating FKs to partitioned tables"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_key`
