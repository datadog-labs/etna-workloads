# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d673eefd410cd7f5f95e418990146189f44811af ("Fix XMLTABLE() deparsing to quote namespace names if necessary."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||xml`
