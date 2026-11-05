# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9effc4608e1f6d19546a0e0f64320f4b0dd10c3c ("Repair ALTER EXTENSION ... SET SCHEMA."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/alter.c, src/backend/commands/extension.c, src/backend/commands/tablecmds.c, src/backend/commands/typecmds.c, src/include/commands/typecmds.h

Failing oracle cases:
- `src/test/modules/test_extensions||test_extensions`
