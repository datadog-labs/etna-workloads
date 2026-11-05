# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d59383924c580a77a2346d9b1284c8589b3d43e2 ("Fix check_exclusion_or_unique_constraint for UNIQUE NULLS NOT DISTINCT."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execIndexing.c

Failing oracle cases:
- `src/test/regress||constraints`
