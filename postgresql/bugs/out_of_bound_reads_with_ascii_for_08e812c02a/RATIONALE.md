# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 08e812c02ae14bbfb03d787884e4c6087419ecf7 ("Fix out-of-bound reads with ascii() for invalid multibyte characters"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/oracle_compat.c

Failing oracle cases:
- `src/test/regress||encoding`
