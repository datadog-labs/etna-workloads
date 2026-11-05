# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2313dda9d493d3685ac7328b49dc6f5a87c1c295 ("Fix check_agg_arguments' examination of aggregate FILTER clauses."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/parser/parse_agg.c

Failing oracle cases:
- `src/test/regress||aggregates`
