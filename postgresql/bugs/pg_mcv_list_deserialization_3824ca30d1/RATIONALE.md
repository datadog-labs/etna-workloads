# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3824ca30d162611fdaade403d3aec449fecd0924 ("Fix pg_mcv_list deserialization"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/statistics/mcv.c

Failing oracle cases:
- `src/test/regress||stats_ext`
