# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2523928b285b06242e0c669fadfc76d73bafdd66 ("Reject change of output-column collation in CREATE OR REPLACE VIEW."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/view.c

Failing oracle cases:
- `src/test/regress||create_view`
