# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 22757960bb3b2a6fa331bad132998c53b3e744a9 ("Fix typo: colums -> columns."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_utilcmd.c

Failing oracle cases:
- `src/test/regress||identity`
