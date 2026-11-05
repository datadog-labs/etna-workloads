# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 53823a06be6f40d88d8e3ba45045ecee1a21fc5e ("Fix failure to set correct operator in window run condition"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/allpaths.c

Failing oracle cases:
- `src/test/regress||window`
