# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e33f2335a9d9754ccf3bf7181085cfa581ee03c3 ("Avoid double transformation of json_array()'s subquery."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_expr.c

Failing oracle cases:
- `src/test/regress||sqljson`
