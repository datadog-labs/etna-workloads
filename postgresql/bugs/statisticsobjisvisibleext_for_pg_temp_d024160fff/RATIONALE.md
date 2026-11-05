# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d024160fffc8065b9b007c6be1b5f907eb2122c9 ("Fix StatisticsObjIsVisibleExt() for pg_temp."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/namespace.c

Failing oracle cases:
- `src/test/regress||stats_ext`
