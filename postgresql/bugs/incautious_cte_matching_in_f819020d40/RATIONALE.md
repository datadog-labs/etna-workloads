# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f819020d400f1dbd96ee1a9fd44a1f6f44932b4d ("Fix incautious CTE matching in rewriteSearchAndCycle()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteSearchCycle.c

Failing oracle cases:
- `src/test/regress||with`
