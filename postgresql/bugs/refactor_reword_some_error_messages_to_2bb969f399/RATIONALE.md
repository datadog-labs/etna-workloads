# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2bb969f3998489e5dc4fe9f2a61185b43581975d ("Refactor/reword some error messages to avoid duplicates"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execExprInterp.c, src/backend/parser/parse_expr.c, src/backend/parser/parse_jsontable.c

Failing oracle cases:
- `src/test/regress||sqljson_jsontable`
- `src/test/regress||sqljson_queryfuncs`
