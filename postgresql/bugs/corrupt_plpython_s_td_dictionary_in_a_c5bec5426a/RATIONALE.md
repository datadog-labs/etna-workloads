# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c5bec5426af989f2a9b0c1f4b97340798fe153f7 ("Don't corrupt plpython's "TD" dictionary in a recursive trigger call."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpython/plpy_exec.c, src/pl/plpython/plpy_procedure.c, src/pl/plpython/plpy_procedure.h

Failing oracle cases:
- `src/pl/plpython||plpython_trigger`
