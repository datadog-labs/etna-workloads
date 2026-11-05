# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 92a30a7eb0cadb008e18053f199af7de3fc1abaa ("Fix broken dependency-mongering for index operator classes/families."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/opclasscmds.c

Failing oracle cases:
- `src/test/regress||create_am`
