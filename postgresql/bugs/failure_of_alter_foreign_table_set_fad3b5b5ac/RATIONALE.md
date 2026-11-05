# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit fad3b5b5acb154725b0265010642ee95fa37c5d7 ("Fix failure of ALTER FOREIGN TABLE SET SCHEMA to move sequences."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_data`
