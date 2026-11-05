# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 641f3dffcdf1c7378cfb94c98b6642793181d6db ("Restore the previous semantics of get_constraint_index()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/cache/lsyscache.c

Failing oracle cases:
- `src/test/regress||alter_table`
