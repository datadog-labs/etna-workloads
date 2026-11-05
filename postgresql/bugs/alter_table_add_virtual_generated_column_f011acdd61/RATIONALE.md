# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f011acdd61fc296ec8822ca4edc18e32b6bd2b56 ("Fix ALTER TABLE ADD VIRTUAL GENERATED COLUMN when table rewrite"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||generated_virtual`
