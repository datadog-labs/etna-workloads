# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 754c610e13b820370db4c02010a4c8c5dbd1edbd ("Fix bitmap table scan crash on iterator release"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeBitmapHeapscan.c, src/backend/nodes/tidbitmap.c

Failing oracle cases:
- `src/test/regress||join`
