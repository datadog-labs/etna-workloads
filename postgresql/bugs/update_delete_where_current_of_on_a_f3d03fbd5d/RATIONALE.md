# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f3d03fbd5d017c8e8e42a3b3bcca696cfd94a8c3 ("Fix UPDATE/DELETE ... WHERE CURRENT OF on a table with virtual columns."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/analyze.c, src/backend/rewrite/rewriteManip.c

Failing oracle cases:
- `src/test/regress||generated_virtual`
