# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 53482fcb94a82cc22e20a7206c508a39aa07a76d ("plpython: Fix NULL pointer dereferences for broken sequence and mapping objects"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpython/plpy_cursorobject.c, src/pl/plpython/plpy_spi.c, src/pl/plpython/plpy_typeio.c

Failing oracle cases:
- `src/pl/plpython||plpython_composite`
- `src/pl/plpython||plpython_spi`
- `src/pl/plpython||plpython_types`
