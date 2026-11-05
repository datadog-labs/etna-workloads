# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c03523ed3fc65e219068aff536330ce451f63ca7 ("PL/Python: Fix crash when colnames() etc. called without result set"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/pl/plpython/plpy_resultobject.c

Failing oracle cases:
- `src/pl/plpython||plpython_spi`
