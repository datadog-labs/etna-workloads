# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0c3185e963d9f9dd0608214f7d732b84aa0888fe ("In security-restricted operations, block enqueue of at-commit user code."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/access/transam/xact.c, src/backend/commands/portalcmds.c, src/backend/commands/trigger.c

Failing oracle cases:
- `src/test/regress||privileges`
