# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 61639816b870347677e6e6945604e0d9da1837ca ("Fix error messages"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/foreigncmds.c, src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_data`
