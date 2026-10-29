# Rationale

In 3.54.1 the fts5_index.c side of the fix is already structured like the
pre-fix code (prefix queries without a prefix index go through
fts5SetupPrefixIter, with the later `prefix-insttoken` mechanism), so only the
two fts5_expr.c hunks were reversed:

1. `fts5ExprPopulatePoslistsCb`: restored
   `bTokendata && !pT->bPrefix` in place of `(bTokendata || pT->bPrefix)`
   (fix hunk 1). Tokendata is no longer written for prefix terms.
2. `sqlite3Fts5ExprInstToken`: restored the pre-fix
   `if( pTerm->bPrefix==0 ){ ... }` wrapper (fix hunk 2), so for prefix terms
   nothing is returned and xInstToken yields an empty token. The call keeps
   today's extra pTerm/nQueryTerm arguments.

## Failing oracle cases
- fts5tokendata 1.5 (all detail modes): `fts5_test_insttoken` on `pe*` returns
  empty instead of `pedagog.Pedagog` etc.
- fts5origintext *-1.5.2/1.5.3/1.6.2/1.6.3 and 2.x equivalents (24 cases):
  tokens for prefix queries come back empty.
