# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1296dcf18b1cf3a064e5981c1655d133f0b1206f ("Fix EPQ crash from missing partition directory in EState"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execMain.c

Failing oracle cases:
- `src/test/isolation||eval-plan-qual`
