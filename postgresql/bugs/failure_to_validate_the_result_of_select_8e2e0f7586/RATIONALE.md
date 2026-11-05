# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8e2e0f75869e47b3a429b1251b00b3d6d5861028 ("Fix failure to validate the result of select_common_type()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_coerce.c, src/backend/parser/parse_expr.c, src/include/parser/parse_coerce.h

Failing oracle cases:
- `src/test/regress||arrays`
- `src/test/regress||expressions`
