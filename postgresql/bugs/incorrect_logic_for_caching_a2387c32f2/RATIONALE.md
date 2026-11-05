# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a2387c32f2f8a1643c7d71b951587e6bcb2d4744 ("Fix incorrect logic for caching ResultRelInfos for triggers"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execMain.c

Failing oracle cases:
- `src/test/regress||foreign_key`
