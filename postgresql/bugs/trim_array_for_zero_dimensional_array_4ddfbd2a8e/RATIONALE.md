# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4ddfbd2a8ea9b41ced0cad1d984c833085f8ce91 ("Fix trim_array() for zero-dimensional array argument."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/arrayfuncs.c

Failing oracle cases:
- `src/test/regress||arrays`
