# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e2395cdbe83adc50ac03dd17474ee88c5a97359a ("ALTER TABLE: rework determination of access method ID"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||create_am`
