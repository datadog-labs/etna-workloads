# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8e8b2bef780e65102ac89260427181fb655c9c3b ("Strip PlaceHolderVars from partition pruning operands"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/indxpath.c, src/backend/optimizer/plan/createplan.c, src/backend/optimizer/util/placeholder.c, src/backend/partitioning/partprune.c, src/include/optimizer/placeholder.h

Failing oracle cases:
- `src/test/regress||partition_prune`
