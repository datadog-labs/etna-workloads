# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 08454e8b2defdf8a0b61e550606f78b8f184f2e6 ("Fix multirange type handling in pg_restore_attribute_stats()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/statistics/attribute_stats.c

Failing oracle cases:
- `src/test/regress||stats_import`
