# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d727c543176c32205372991d3e036e5349fb719d ("Fix recursive RECORD-returning plpython functions."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpython/plpy_exec.c

Failing oracle cases:
- `src/pl/plpython||plpython_composite`
