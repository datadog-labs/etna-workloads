# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2d0152d6147bb7d12eb120b7e749a323bf91aa6e ("Improve the error message introduced in commit 87ce27de696."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execReplication.c

Failing oracle cases:
- `src/test/regress||publication`
