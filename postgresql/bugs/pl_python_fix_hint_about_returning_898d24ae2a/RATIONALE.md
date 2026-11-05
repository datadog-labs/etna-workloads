# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 898d24ae2ad7195869c558eb6c126ff6a90474e8 ("PL/Python: Fix hint about returning composite type from Python"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/pl/plpython/plpy_typeio.c

Failing oracle cases:
- `src/pl/plpython||plpython_composite`
