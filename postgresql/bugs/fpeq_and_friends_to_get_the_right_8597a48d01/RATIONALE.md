# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8597a48d01b6cc0b09ff626253ac93c67e5516d5 ("Fix FPeq() and friends to get the right answers for infinities."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/geo_ops.c, src/include/utils/geo_decls.h

Failing oracle cases:
- `src/test/regress||geometry`
