# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 802308693f2f55704751657986abdc81f76ee4cf ("Amend recent fix for SIMILAR TO regex conversion."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/regexp.c

Failing oracle cases:
- `src/test/regress||strings`
