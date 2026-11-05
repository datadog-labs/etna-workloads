# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 543d22fc7423747afd59fe7214f2ddf6259efc62 ("Prevent invoking I/O conversion casts via functional/attribute notation."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_func.c

Failing oracle cases:
- `src/test/regress||rowtypes`
