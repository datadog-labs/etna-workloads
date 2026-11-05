# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7da51590ed6cd46ff886e8e4d08e8703db9c2b5b ("Fix incorrect presorted DISTINCT aggregate if condition"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/execExprInterp.c

Failing oracle cases:
- `src/test/regress||aggregates`
