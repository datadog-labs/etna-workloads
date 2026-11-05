# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f6db76c55509a60cc8c22ced56ff9322ee6f1742 ("Prevent join removal from removing the query's result relation."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/analyzejoins.c

Failing oracle cases:
- `src/test/regress||merge`
