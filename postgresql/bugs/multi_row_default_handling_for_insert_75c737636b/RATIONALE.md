# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 75c737636b8a1e9a110e580f1caee181023447e2 ("Fix multi-row DEFAULT handling for INSERT ... SELECT rules."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteHandler.c, src/backend/rewrite/rewriteManip.c

Failing oracle cases:
- `src/test/regress||updatable_views`
