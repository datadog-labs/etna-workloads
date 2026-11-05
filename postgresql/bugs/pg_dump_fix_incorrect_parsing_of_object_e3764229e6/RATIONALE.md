# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e3764229e6bdcc71b03642a2f9cd728cca361889 ("pg_dump: Fix incorrect parsing of object types in pg_dump --filter."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_dump/filter.c

Failing oracle cases:
- `src/bin/pg_dump|t/005_pg_dump_filterfile.pl|invalid syntax: invalid object type specified: exit code not 0`
- `src/bin/pg_dump|t/005_pg_dump_filterfile.pl|invalid syntax: invalid object type specified: matches`
