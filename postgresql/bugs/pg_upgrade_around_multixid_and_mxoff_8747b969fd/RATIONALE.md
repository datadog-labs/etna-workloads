# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8747b969fd8be79541f6e3cdb99e1b425fd9ad47 ("Fix pg_upgrade around multixid and mxoff wraparound"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_resetwal/pg_resetwal.c

Failing oracle cases:
- `src/bin/pg_resetwal|t/001_basic.pl|fails with -O value -1: matches`
- `src/bin/pg_resetwal|t/001_basic.pl|succeeds with -m value 0 part 1`
