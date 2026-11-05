# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6e045e1a6e3f1a55d3d246f8258f3316410b26f6 ("Fix SUBSTRING() for toasted multibyte characters."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/varlena.c

Failing oracle cases:
- `src/test/regress||encoding`
