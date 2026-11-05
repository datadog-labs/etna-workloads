# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e4527519b77e0f158e452fcbbcb2ac902d01ad44 ("Fix propagation of indimmediate flag in index_create_copy()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/index.c, src/backend/commands/indexcmds.c, src/include/catalog/index.h

Failing oracle cases:
- `src/test/modules/injection_points||reindex_concurrently_deferred`
