# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 098fb00799ffb026ff12c64bd21635f963cfc609 ("Ignore attempts to \gset into specially treated variables."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/common.c, src/bin/psql/variables.c, src/bin/psql/variables.h

Failing oracle cases:
- `src/test/regress||psql`
