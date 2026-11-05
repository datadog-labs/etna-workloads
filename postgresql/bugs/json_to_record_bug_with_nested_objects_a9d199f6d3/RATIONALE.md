# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a9d199f6d3b998929cdb8e8aa61e5cd8db9b220f ("Fix json_to_record() bug with nested objects."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonfuncs.c

Failing oracle cases:
- `src/test/regress||json`
