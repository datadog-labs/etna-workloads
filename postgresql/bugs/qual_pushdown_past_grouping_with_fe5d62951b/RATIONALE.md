# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit fe5d62951b3ccd382a530b790c3c2cb508b97c8c ("Fix qual pushdown past grouping with mismatched equivalence"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/allpaths.c, src/backend/optimizer/plan/planner.c, src/backend/optimizer/util/clauses.c, src/backend/utils/cache/lsyscache.c, src/include/optimizer/clauses.h, src/include/utils/lsyscache.h

Failing oracle cases:
- `src/test/regress||aggregates`
- `src/test/regress||collate.icu.utf8`
- `src/test/regress||subselect`
