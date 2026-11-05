# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 55f4802785f66a584c05dca40e5d9b25491674b2 ("Prevent write operations on large objects in read-only transactions"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/libpq/be-fsstubs.c

Failing oracle cases:
- `src/test/regress||largeobject`
