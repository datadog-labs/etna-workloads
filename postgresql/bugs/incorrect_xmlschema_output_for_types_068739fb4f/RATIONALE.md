# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 068739fb4f345c8c922d72f2c8e15e9c0a75056d ("Fix incorrect xmlschema output for types timetz and timestamptz."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/xml.c

Failing oracle cases:
- `src/test/regress||xmlmap`
