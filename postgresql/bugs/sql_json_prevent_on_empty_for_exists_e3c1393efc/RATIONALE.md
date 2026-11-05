# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e3c1393efc31ac70de7b68e9a283ec3f2d7f9bd2 ("SQL/JSON: Prevent ON EMPTY for EXISTS columns in JSON_TABLE()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/gram.y

Failing oracle cases:
- `src/test/regress||sqljson_jsontable`
