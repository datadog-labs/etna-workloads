# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7e085aabd5759c73d25556a5963866d5beaea5cd ("vacuumdb: Fix --missing-stats-only for partitioned indexes."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/scripts/vacuumdb.c

Failing oracle cases:
- `src/bin/scripts|t/100_vacuumdb.pl|--missing-stats-only with no missing partition stats: SQL not found in server log`
