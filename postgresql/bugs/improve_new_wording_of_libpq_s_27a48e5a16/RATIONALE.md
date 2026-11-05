# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 27a48e5a16ff2227ddf44ee717d9bcd89d22a7aa ("Improve new wording of libpq's connection failure messages."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/interfaces/libpq/fe-connect.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|connecting to a non-existent database: matches`
- `src/bin/pg_dump|t/002_pg_dump.pl|connecting to an invalid database: matches`
- `src/interfaces/ecpg||connect/test5`
