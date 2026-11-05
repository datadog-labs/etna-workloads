# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a397109114c8569e21ed3c858a16143de28a1897 ("psql: Fix name quoting on extended statistics"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/describe.c

Failing oracle cases:
- `src/test/regress||create_table_like`
- `src/test/regress||stats_ext`
