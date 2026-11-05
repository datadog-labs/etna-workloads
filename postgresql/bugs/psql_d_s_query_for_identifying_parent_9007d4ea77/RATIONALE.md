# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9007d4ea774edd815efeb0e0ef954127841beb2f ("Fix psql \d's query for identifying parent triggers."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/describe.c

Failing oracle cases:
- `src/test/regress||triggers`
