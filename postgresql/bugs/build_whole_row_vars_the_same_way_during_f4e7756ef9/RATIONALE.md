# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f4e7756ef9a437f30a4dc5ded41b8824a9d291b9 ("Build whole-row Vars the same way during parsing and planning."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/nodes/makefuncs.c, src/backend/optimizer/prep/prepjointree.c

Failing oracle cases:
- `src/test/regress||returning`
