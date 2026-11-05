# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a93e2a1e25a6d5410abb1446637c4d9a4f24e35d ("Fix JsonExpr deparsing to quote variable names in the PASSING clause."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||sqljson_queryfuncs`
