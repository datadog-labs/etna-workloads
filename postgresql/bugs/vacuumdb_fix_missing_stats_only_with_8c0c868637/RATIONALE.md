# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8c0c8686374495815c2c970e8652228c5aac4495 ("vacuumdb: Fix --missing-stats-only with virtual generated columns."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/scripts/vacuumdb.c

Failing oracle cases:
- `src/bin/scripts|t/100_vacuumdb.pl|--missing-stats-only with no missing extended stats: SQL not found in server log`
- `src/bin/scripts|t/100_vacuumdb.pl|--missing-stats-only with no missing index expression stats: SQL not found in server log`
- `src/bin/scripts|t/100_vacuumdb.pl|--missing-stats-only with no missing inherited stats: SQL not found in server log`
- `src/bin/scripts|t/100_vacuumdb.pl|--missing-stats-only with no missing stats: SQL not found in server log`
