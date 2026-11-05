# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0e1275fb073cbbff2185f4067d67785e56941e50 ("Avoid using ambiguous word "non-negative" in error messages."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/partitioning/partbounds.c, src/backend/utils/adt/tsquery_op.c

Failing oracle cases:
- `src/test/regress||hash_part`
