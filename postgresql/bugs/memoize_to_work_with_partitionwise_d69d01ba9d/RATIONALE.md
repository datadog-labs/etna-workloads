# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d69d01ba9d8d774487032459ebb83d2086715f01 ("Fix Memoize to work with partitionwise joining."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/joinpath.c, src/backend/optimizer/util/pathnode.c, src/include/nodes/pathnodes.h

Failing oracle cases:
- `src/test/regress||memoize`
