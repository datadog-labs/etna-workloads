# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 991f8cf8abe244547093ddffcc4b9209076f3525 ("Detect integer overflow in array_set_slice()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/arrayfuncs.c

Failing oracle cases:
- `src/test/regress||arrays`
