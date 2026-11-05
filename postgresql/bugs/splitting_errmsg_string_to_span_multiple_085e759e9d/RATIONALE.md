# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 085e759e9da77b7f5e859d23f72653f36277a053 ("Avoid splitting errmsg string to span multiple lines"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/parser/parse_expr.c

Failing oracle cases:
- `src/test/regress||sqljson_queryfuncs`
