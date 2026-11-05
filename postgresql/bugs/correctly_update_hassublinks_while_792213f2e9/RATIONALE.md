# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 792213f2e9f6d321d5a463f4a0fc263c2b770ac3 ("Correctly update hasSubLinks while mutating a rule action."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteHandler.c

Failing oracle cases:
- `src/test/regress||updatable_views`
