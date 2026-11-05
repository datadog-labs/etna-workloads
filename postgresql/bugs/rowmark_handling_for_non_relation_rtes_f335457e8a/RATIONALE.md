# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f335457e8adb32ce2e506e0d2b62c7f6f4bb98d1 ("Fix rowmark handling for non-relation RTEs during executor init"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execMain.c, src/backend/executor/nodeLockRows.c, src/backend/executor/nodeModifyTable.c

Failing oracle cases:
- `src/test/isolation||eval-plan-qual`
