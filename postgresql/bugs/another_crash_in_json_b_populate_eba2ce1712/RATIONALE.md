# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit eba2ce17121f198316d050e71d8bd049a43783ba ("Fix another crash in json{b}_populate_recordset and json{b}_to_recordset."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonfuncs.c

Failing oracle cases:
- `src/test/regress||json`
- `src/test/regress||jsonb`
