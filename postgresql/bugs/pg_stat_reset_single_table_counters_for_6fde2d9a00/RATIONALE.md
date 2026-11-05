# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6fde2d9a005a5bc04aa059d3faeb865c8dd322ce ("Fix pg_stat_reset_single_table_counters() for shared relations"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/pgstatfuncs.c

Failing oracle cases:
- `src/test/regress||stats`
