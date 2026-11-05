# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 29f7ce6fe78e3f8d520764b5870453d791a3ca65 ("Fix deparsing FETCH FIRST <expr> ROWS WITH TIES"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||limit`
