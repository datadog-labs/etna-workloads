# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a4faef8f8fe1493397679c014cf11a6e27c0f1e5 ("Fix some corner cases for window ranges with infinite offsets."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/float.c

Failing oracle cases:
- `src/test/regress||window`
