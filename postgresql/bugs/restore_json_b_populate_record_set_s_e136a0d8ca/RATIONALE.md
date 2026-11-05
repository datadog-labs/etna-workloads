# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e136a0d8ca31d1c94b3f2868ae0e735b8d9ff12f ("Restore json{b}_populate_record{set}'s ability to take type info from AS."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonfuncs.c

Failing oracle cases:
- `src/test/regress||json`
- `src/test/regress||jsonb`
