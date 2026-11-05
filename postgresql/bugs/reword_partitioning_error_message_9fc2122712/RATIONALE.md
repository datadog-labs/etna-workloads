# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9fc21227128980f88b6eb6d5306625af0428ef45 ("Reword partitioning error message"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/indexcmds.c

Failing oracle cases:
- `src/test/regress||indexing`
