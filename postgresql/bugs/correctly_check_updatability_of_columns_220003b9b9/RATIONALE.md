# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 220003b9b93729af1ffa861d1ae5f4724ce22cd8 ("Correctly check updatability of columns targeted by INSERT...DEFAULT."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteHandler.c

Failing oracle cases:
- `src/test/regress||updatable_views`
