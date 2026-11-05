# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cabfb8241dea84206b90578a769e9cbd813ba477 ("Fix psql's \sf and \ef for new-style SQL functions."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c, src/bin/psql/command.c

Failing oracle cases:
- `src/test/regress||psql`
