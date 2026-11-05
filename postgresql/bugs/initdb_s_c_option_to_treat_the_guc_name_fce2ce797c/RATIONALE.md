# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit fce2ce797c412df8b794b8a92c5a586db5e1bedc ("Fix initdb's -c option to treat the GUC name case-insensitively."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/initdb/initdb.c

Failing oracle cases:
- `src/bin/initdb|t/001_initdb.pl|WORK_MEM should not be configured`
- `src/bin/initdb|t/001_initdb.pl|Work_Mem should not be configured`
- `src/bin/initdb|t/001_initdb.pl|work_mem should be in config`
