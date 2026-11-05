# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4618045bee4a6d3efcb489c319649d8dd9aaa738 ("Fix ARRAY_SUBLINK and ARRAY[] for int2vector and oidvector input."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_expr.c, src/backend/utils/adt/arrayfuncs.c

Failing oracle cases:
- `src/test/regress||arrays`
