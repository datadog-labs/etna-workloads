# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9d4ca01314ba0c571139c5560a40ef764ad0feee ("Ensure that a tsquery like '!foo' matches empty tsvectors."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/tsvector_op.c

Failing oracle cases:
- `src/test/regress||tsearch`
- `src/test/regress||tstypes`
