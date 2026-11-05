# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7a3972597f6ed7a6976d81abb66c38a7a1c29058 ("Fix out-of-bound memory access for interval -> char conversion"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/formatting.c

Failing oracle cases:
- `src/test/regress||timestamp`
