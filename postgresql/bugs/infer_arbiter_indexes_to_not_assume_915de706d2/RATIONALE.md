# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 915de706d28c433283e9dc63701e8f978488a2b9 ("Fix infer_arbiter_indexes() to not assume resultRelation is 1."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/plancat.c

Failing oracle cases:
- `src/test/regress||insert_conflict`
