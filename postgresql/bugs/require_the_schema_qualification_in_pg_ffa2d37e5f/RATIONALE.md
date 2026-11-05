# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ffa2d37e5fbd1243f918f622113d6e371667e5a0 ("Require the schema qualification in pg_temp.type_name(arg)."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/namespace.c, src/backend/parser/parse_func.c, src/backend/parser/parse_type.c, src/backend/utils/adt/ruleutils.c, src/include/catalog/namespace.h, src/include/parser/parse_type.h

Failing oracle cases:
- `src/test/regress||temp`
