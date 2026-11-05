# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 72d172743e52f31bb874e3bbc07544b30bf0bb51 ("pg_rewind: Fix thinko in parsing target WAL."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_rewind/filemap.c

Failing oracle cases:
- `src/bin/pg_rewind|t/001_basic.pl|drop: psql exit code`
- `src/bin/pg_rewind|t/001_basic.pl|drop: psql exit code#2`
- `src/bin/pg_rewind|t/001_basic.pl|drop: psql exit code#3`
- `src/bin/pg_rewind|t/001_basic.pl|drop: psql no stderr`
- `src/bin/pg_rewind|t/001_basic.pl|drop: psql no stderr#2`
- `src/bin/pg_rewind|t/001_basic.pl|drop: psql no stderr#3`
- `src/bin/pg_rewind|t/001_basic.pl|drop: query result matches`
- `src/bin/pg_rewind|t/001_basic.pl|drop: query result matches#2`
- `src/bin/pg_rewind|t/001_basic.pl|drop: query result matches#3`
- `src/bin/pg_rewind|t/001_basic.pl|pg_rewind --dry-run`
- `src/bin/pg_rewind|t/001_basic.pl|pg_rewind archive`
- `src/bin/pg_rewind|t/001_basic.pl|pg_rewind local`
- `src/bin/pg_rewind|t/001_basic.pl|pg_rewind remote`
- `src/bin/pg_rewind|t/001_basic.pl|recovery conf file sets dbname`
- `src/bin/pg_rewind|t/001_basic.pl|standby.signal created after pg_rewind`
- `src/bin/pg_rewind|t/001_basic.pl|table content: query result matches`
- `src/bin/pg_rewind|t/001_basic.pl|table content: query result matches#2`
- `src/bin/pg_rewind|t/001_basic.pl|table content: query result matches#3`
- `src/bin/pg_rewind|t/001_basic.pl|table content: query result matches#4`
- `src/bin/pg_rewind|t/001_basic.pl|table content: query result matches#5`
- `src/bin/pg_rewind|t/001_basic.pl|table content: query result matches#6`
- `src/bin/pg_rewind|t/001_basic.pl|tail-copy: query result matches`
- `src/bin/pg_rewind|t/001_basic.pl|tail-copy: query result matches#2`
- `src/bin/pg_rewind|t/001_basic.pl|tail-copy: query result matches#3`
- `src/bin/pg_rewind|t/001_basic.pl|truncation: query result matches`
- `src/bin/pg_rewind|t/001_basic.pl|truncation: query result matches#2`
- `src/bin/pg_rewind|t/001_basic.pl|truncation: query result matches#3`
