# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f535f350c1f9b5a9c4f10583992576c3af505275 ("Fix handling of polymorphic output arguments for procedures."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/functioncmds.c

Failing oracle cases:
- `src/test/regress||create_procedure`
