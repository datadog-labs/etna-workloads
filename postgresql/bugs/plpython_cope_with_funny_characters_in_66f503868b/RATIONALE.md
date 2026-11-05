# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 66f503868b2ac1163aaf48a2f76d8be02af0bc81 ("Make plpython cope with funny characters in function names."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/pl/plpython/plpy_procedure.c

Failing oracle cases:
- `src/pl/plpython||plpython_test`
