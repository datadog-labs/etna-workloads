# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3d7a96871c71dc0e6d2614eb4a68179bc7e383db ("Obtain required table lock during cross-table updates, redux."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||alter_table`
- `src/test/regress||generated_stored`
- `src/test/regress||generated_virtual`
