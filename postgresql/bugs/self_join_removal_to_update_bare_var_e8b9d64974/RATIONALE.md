# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e8b9d6497469dadb3c2f3765dfeed7432af77704 ("Fix self-join removal to update bare Var references in join clauses"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteManip.c

Failing oracle cases:
- `src/test/regress||join`
