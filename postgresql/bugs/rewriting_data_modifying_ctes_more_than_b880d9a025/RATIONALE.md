# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b880d9a025bd58d24e8bf03e64839794e7a982d9 ("Avoid rewriting data-modifying CTEs more than once."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteHandler.c

Failing oracle cases:
- `src/test/regress||with`
