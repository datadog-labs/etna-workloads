# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c11f87b1a3b97d23468bdffd2aba17298f1cb3e0 ("Fix dependency on FDW handler."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/foreigncmds.c

Failing oracle cases:
- `src/test/regress||foreign_data`
