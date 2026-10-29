# Rationale

Fix hunk (src/wherecode.c): replaced `assert( pOrigRhs->a[iField].pExpr!=0 )` with
`if( ...==0 ) continue; /* Duplicate PK column */`.

## Changes
1. `src/wherecode.c` `removeUnindexableInClauseTerms()`: the
   `if( NEVER(pOrigRhs->a[iField].pExpr==0) ){ continue; }` guard is replaced with the
   pre-fix `assert( pOrigRhs->a[iField].pExpr!=0 );`. This reverses the fix hunk directly.
2. `src/where.c` `whereLoopAddBtreeIndex()`: removed the later `bRedundant` check
   (tag-20250707-01), which stops a WhereLoop from holding two terms for the same
   vector-IN field. It covers the same defect (PK/index with duplicate columns, e.g.
   `PRIMARY KEY(b,b)`, matching one IN field twice) from the planner side, so with it
   present, change 1 alone cannot trigger the bug.

## Oracle
`rowvalue-21.0` fails: `CREATE TABLE t1(a,b,PRIMARY KEY(b,b)); SELECT * FROM t1 WHERE (a,b) IN (VALUES(1,2));`
aborts with `Assertion 'pOrigRhs->a[iField].pExpr!=0' failed` in removeUnindexableInClauseTerms.
