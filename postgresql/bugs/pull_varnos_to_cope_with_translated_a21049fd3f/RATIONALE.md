# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a21049fd3f64518c8a7227cf07c56f2543241db2 ("Fix pull_varnos to cope with translated PlaceHolderVars."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/util/var.c

Failing oracle cases:
- `src/test/regress||join`
