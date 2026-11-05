# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 178ec460db0a0ced46ac5a01a28a704ca6251e53 ("Fixes for multirange selectivity estimation"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/multirangetypes_selfuncs.c

Failing oracle cases:
- `src/test/regress||multirangetypes`
