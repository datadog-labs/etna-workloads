# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 55173d2e663fbe32430665ce7bd65a47856dc237 ("Fix failure to create FKs correctly in partitions"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_key`
