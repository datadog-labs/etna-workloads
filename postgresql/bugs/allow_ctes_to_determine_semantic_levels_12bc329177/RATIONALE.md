# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 12bc3291772e29fdf2850c890ba9b962b07a1c1c ("Don't allow CTEs to determine semantic levels of aggregates."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_agg.c

Failing oracle cases:
- `src/test/regress||with`
