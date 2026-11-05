# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 170aec63cd7139b453c52ad52bbeb83993faa31d ("Avoid using ambiguous word "positive" in error message."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_utilcmd.c

Failing oracle cases:
- `src/test/regress||alter_table`
- `src/test/regress||create_table`
