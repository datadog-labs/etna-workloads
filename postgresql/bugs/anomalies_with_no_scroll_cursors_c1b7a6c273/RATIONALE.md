# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c1b7a6c2731241cf5af4c08de54a64fc8999d727 ("Fix some anomalies with NO SCROLL cursors."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/portalcmds.c, src/backend/tcop/pquery.c

Failing oracle cases:
- `src/test/regress||portals`
