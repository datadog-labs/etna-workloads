# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 58ea074f1433abdd5de792e47ae84c1e56c263f9 ("Fix semijoin unique-ification for child relations"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/pathnode.c

Failing oracle cases:
- `src/test/regress||join`
