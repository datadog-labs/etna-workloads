# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3d99a81397abb8bb7b95aee794d6644e174e174f ("Fix incorrect printing of queries with duplicated join names."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||create_view`
