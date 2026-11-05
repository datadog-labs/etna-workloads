# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit af5b3c3d1eae94e9584ad1955a20b5a7cd0083c1 ("Fix assertion failure with PL/Python exceptions"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/pl/plpython/plpy_elog.c

Failing oracle cases:
- `src/pl/plpython||plpython_error`
