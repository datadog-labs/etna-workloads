# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1aa7cf9eb85972aaf2969306e84f5fc794fbef7f ("Disallow removing placeholders during Self-Join Elimination."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/analyzejoins.c

Failing oracle cases:
- `src/test/regress||join`
