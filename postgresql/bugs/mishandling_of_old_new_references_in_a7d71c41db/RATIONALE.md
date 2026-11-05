# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a7d71c41dbd691ac86cc47114dab9db4b31f27ad ("Fix mishandling of OLD/NEW references in subqueries in rule actions."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteHandler.c

Failing oracle cases:
- `src/test/regress||rules`
