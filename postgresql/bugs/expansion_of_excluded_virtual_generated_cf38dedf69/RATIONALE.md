# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cf38dedf693a17f9317d8ed85ab7468afebf8cbf ("Fix expansion of EXCLUDED virtual generated columns."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/prep/prepjointree.c

Failing oracle cases:
- `src/test/regress||generated_virtual`
