# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9a82a64edcd8615cf16eae64bf1572d4156cb912 ("Fix EPQ crash from missing partition pruning state in EState"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/execMain.c

Failing oracle cases:
- `src/test/isolation||eval-plan-qual`
