# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2e91f8548daa7c7c7d5848f3812fac95fe9e9db5 ("Check for USAGE privilege on the subtype in CREATE TYPE AS RANGE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/typecmds.c

Failing oracle cases:
- `src/test/regress||rangetypes`
