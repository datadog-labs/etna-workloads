# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0f271e8e8d9c8db0ea86c0d12b3221009b81d8bf ("SQL/JSON: Correct jsonpath variable name matching"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execExpr.c, src/backend/utils/adt/jsonpath_exec.c, src/include/utils/jsonpath.h

Failing oracle cases:
- `src/test/regress||sqljson_queryfuncs`
