# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bf227926d22b5cffba4b6724df0eb239a7037cbd ("Fix pg_rewind with in-place tablespaces when source is remote"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_rewind/libpq_source.c

Failing oracle cases:
- `src/bin/pg_rewind|t/001_basic.pl|drop: psql exit code#2`
- `src/bin/pg_rewind|t/001_basic.pl|drop: psql no stderr#2`
- `src/bin/pg_rewind|t/001_basic.pl|drop: query result matches#2`
- `src/bin/pg_rewind|t/001_basic.pl|pg_rewind remote`
- `src/bin/pg_rewind|t/001_basic.pl|recovery conf file sets dbname`
- `src/bin/pg_rewind|t/001_basic.pl|standby.signal created after pg_rewind`
- `src/bin/pg_rewind|t/001_basic.pl|table content: query result matches#3`
- `src/bin/pg_rewind|t/001_basic.pl|table content: query result matches#4`
- `src/bin/pg_rewind|t/001_basic.pl|tail-copy: query result matches#2`
- `src/bin/pg_rewind|t/001_basic.pl|truncation: query result matches#2`
