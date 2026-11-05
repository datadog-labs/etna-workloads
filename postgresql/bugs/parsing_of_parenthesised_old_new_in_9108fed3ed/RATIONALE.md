# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9108fed3eda97475d5ef2f9060f6bc1f61783346 ("Fix parsing of parenthesised OLD/NEW in RETURNING list."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_coerce.c, src/backend/parser/parse_func.c, src/backend/parser/parse_relation.c, src/backend/parser/parse_target.c, src/include/parser/parse_relation.h

Failing oracle cases:
- `src/test/regress||returning`
