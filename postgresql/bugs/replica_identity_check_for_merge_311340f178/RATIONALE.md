# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 311340f17863b0f87b3af32649ee5a2a58988b08 ("Fix replica identity check for MERGE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execMain.c

Failing oracle cases:
- `src/test/regress||publication`
