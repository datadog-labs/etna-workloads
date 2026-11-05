# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 57f59ca1d954f2de7ac3ef8971046778c955613a ("Check for USAGE privilege on the composite type in ALTER TABLE OF."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||privileges`
