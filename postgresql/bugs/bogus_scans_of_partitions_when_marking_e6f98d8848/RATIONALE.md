# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e6f98d8848f1803fda32011998c786a1bf4eb87c ("Avoid bogus scans of partitions when marking FKs enforced"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_key`
