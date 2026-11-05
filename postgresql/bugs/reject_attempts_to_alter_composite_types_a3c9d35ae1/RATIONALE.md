# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a3c9d35ae168864bf7999b06e27dabe65a0915e9 ("Reject attempts to alter composite types used in indexes."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||alter_table`
