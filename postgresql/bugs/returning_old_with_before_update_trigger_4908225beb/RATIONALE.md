# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4908225bebdc31c9b8f735ad1db3d08d9bc85148 ("Fix RETURNING OLD with BEFORE UPDATE trigger and concurrent update."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c

Failing oracle cases:
- `src/test/isolation||eval-plan-qual-trigger`
