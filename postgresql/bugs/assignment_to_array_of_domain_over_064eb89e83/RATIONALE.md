# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 064eb89e83ea0f59426c92906329f1e6c423dfa4 ("Fix assignment to array of domain over composite, redux."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execExpr.c

Failing oracle cases:
- `src/test/regress||domain`
