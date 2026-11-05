# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1218780ccebace6a4c4d5872d7b158aa36e6882e ("Un-break whole-row Vars referencing domain-over-composite types."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execExprInterp.c

Failing oracle cases:
- `src/test/regress||domain`
