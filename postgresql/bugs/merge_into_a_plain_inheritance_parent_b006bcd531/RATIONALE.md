# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b006bcd5310eb2dad0828a286b79babce4953143 ("Fix MERGE into a plain inheritance parent table."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c

Failing oracle cases:
- `src/test/regress||merge`
