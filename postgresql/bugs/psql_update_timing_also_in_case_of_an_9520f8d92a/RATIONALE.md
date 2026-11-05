# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9520f8d92a8681e441cc863422babd544353dd39 ("psql: Update \timing also in case of an error"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/common.c

Failing oracle cases:
- `src/bin/psql|t/001_basic.pl|\timing with query error: timing was updated`
