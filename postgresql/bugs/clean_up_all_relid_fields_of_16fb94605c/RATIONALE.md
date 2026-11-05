# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 16fb94605c8f73e113d100ebb9e1d96642c85767 ("Clean up all relid fields of RestrictInfos during join removal."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/analyzejoins.c

Failing oracle cases:
- `src/test/regress||join`
