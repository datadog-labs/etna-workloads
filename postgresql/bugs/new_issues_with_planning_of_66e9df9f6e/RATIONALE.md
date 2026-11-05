# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 66e9df9f6ef50719b25ca63b60aad934e14f4a1c ("Fix some new issues with planning of PlaceHolderVars."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/createplan.c, src/backend/optimizer/util/paramassign.c, src/backend/optimizer/util/placeholder.c, src/include/optimizer/paramassign.h, src/include/optimizer/placeholder.h

Failing oracle cases:
- `src/test/regress||join`
