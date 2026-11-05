# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e6c45d85dc168fb05b5ee5596a4de5167c9fe01f ("SQL/JSON: Fix JSON_QUERY(... WITH CONDITIONAL WRAPPER)"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonpath_exec.c

Failing oracle cases:
- `src/test/regress||sqljson_queryfuncs`
