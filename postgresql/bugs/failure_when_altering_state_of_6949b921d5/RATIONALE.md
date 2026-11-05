# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6949b921d545809a83f8a6bad4948f9012a76fb6 ("Avoid failure when altering state of partitioned foreign-key triggers."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c, src/backend/commands/trigger.c, src/include/commands/trigger.h

Failing oracle cases:
- `src/test/regress||triggers`
