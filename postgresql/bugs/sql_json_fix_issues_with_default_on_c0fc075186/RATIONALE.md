# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c0fc0751862d4e9b7ca9d51f2cd79344690ec873 ("SQL/JSON: Fix issues with DEFAULT .. ON ERROR / EMPTY"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/parser/parse_expr.c

Failing oracle cases:
- `src/test/regress||sqljson_jsontable`
- `src/test/regress||sqljson_queryfuncs`
