# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cc2ca9319a5dbe89ea47d87944650e65e3bb4ce8 ("Fix deparsing of ON CONFLICT arbiter WHERE clauses."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||rules`
