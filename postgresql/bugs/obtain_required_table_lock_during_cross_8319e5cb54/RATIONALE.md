# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8319e5cb5493046e65d60da3cc17ab78c91749b1 ("Obtain required table lock during cross-table constraint updates."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||alter_table`
