# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5d8aa8bcedae7376bd97e79052d606db4e4f8dd4 ("Fix missed optimization in relation_excluded_by_constraints()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/plancat.c

Failing oracle cases:
- `src/test/regress||join`
