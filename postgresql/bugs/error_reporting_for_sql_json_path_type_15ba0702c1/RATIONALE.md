# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 15ba0702c1ae9d46f49a6e1f80db99167d3aedf7 ("Fix error reporting for SQL/JSON path type mismatches"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_expr.c

Failing oracle cases:
- `src/test/regress||sqljson_queryfuncs`
