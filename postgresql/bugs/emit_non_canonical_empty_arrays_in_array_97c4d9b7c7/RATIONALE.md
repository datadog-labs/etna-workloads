# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 97c4d9b7c71519d9dc281394af2c4bcb28bdf136 ("Don't emit non-canonical empty arrays in array_remove()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/arrayfuncs.c

Failing oracle cases:
- `src/test/regress||arrays`
