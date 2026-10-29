# Rationale

Fix: `assert( pTab->nCol>0 || pParse->nErr )` in lookupName() (src/resolve.c) was
a bad assert: when a FROM-clause subquery such as `(SELECT*)` fails expansion
("no tables specified"), its pseudo-table has nCol==0 while pParse->nErr is set.

## Changes
1. src/resolve.c lookupName(): assert restored to `assert( pTab->nCol>0 );` (reverses the fix hunk exactly).
2. In 3.54.1 the assert is no longer reachable, because later code stops once an error is
   recorded. Two such error guards were removed so the pre-fix flow (continue resolving names
   after the subquery error) is back:
   - src/select.c sqlite3SelectPrep(): removed `if( pParse->nErr ) return;` after sqlite3SelectExpand().
   - src/resolve.c resolveSelectStep(): removed `if( pParse->nErr ) return WRC_Abort;` after
     sqlite3ResolveSelectNames() on a FROM subquery.
   Both are needed; either alone leaves the assert unreachable.

## Oracle failure
altertab-32.0 (ALTER TABLE RENAME with trigger `UPDATE t1 SET x=x FROM (SELECT*)`) aborts with
`lookupName: Assertion 'pTab->nCol>0' failed` instead of returning
`1 {error in trigger r1: no tables specified}`. Other cases are unaffected.
