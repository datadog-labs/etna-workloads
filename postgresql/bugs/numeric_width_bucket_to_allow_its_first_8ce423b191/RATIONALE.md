# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8ce423b1912b8303dbec5dc3ec78a7a725acf6c2 ("Fix numeric width_bucket() to allow its first argument to be infinite."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/numeric.c

Failing oracle cases:
- `src/test/regress||numeric`
