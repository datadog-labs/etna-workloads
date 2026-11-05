# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 441e4c8d699910ea21f7f31ae7e76dbc1e572e05 ("Enforce RETURNING typmod on SQL/JSON DEFAULT behavior expressions"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_expr.c

Failing oracle cases:
- `src/test/regress||sqljson_jsontable`
- `src/test/regress||sqljson_queryfuncs`
