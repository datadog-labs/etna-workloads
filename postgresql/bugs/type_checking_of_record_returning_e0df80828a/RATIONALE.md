# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e0df80828abc0c01fcde123389032370b98f2015 ("Fix type-checking of RECORD-returning functions in FROM, redux."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/dependency.c, src/backend/optimizer/prep/prepjointree.c, src/backend/optimizer/util/clauses.c, src/backend/parser/parse_relation.c, src/backend/utils/fmgr/funcapi.c

Failing oracle cases:
- `src/test/regress||rangefuncs`
