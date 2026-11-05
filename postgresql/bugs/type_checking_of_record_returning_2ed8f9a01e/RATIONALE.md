# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2ed8f9a01e74bfc63a56b2108f44237bc5eab9f5 ("Fix type-checking of RECORD-returning functions in FROM."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeFunctionscan.c, src/backend/optimizer/util/clauses.c

Failing oracle cases:
- `src/test/regress||rangefuncs`
