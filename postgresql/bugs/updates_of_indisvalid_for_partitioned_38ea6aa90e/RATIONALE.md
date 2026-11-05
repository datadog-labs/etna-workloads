# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 38ea6aa90e615fc91c138fc1efbc981ef3b434f8 ("Fix updates of indisvalid for partitioned indexes"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||indexing`
