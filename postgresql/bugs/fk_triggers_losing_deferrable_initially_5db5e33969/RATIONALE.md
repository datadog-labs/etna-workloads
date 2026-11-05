# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5db5e339692ed98adb5ae6ff625a92b49f770a6f ("Fix FK triggers losing DEFERRABLE/INITIALLY DEFERRED when marked ENFORCED again"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_key`
