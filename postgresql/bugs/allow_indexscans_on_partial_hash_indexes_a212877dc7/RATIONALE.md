# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a212877dc7293cb05cf8f635f438f38e9161265e ("Allow indexscans on partial hash indexes with implied quals."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/indxpath.c

Failing oracle cases:
- `src/test/regress||hash_index`
