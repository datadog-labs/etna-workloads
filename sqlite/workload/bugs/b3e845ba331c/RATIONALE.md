# Rationale

The fix added `|| pIter->bEof` in fts5ExprNodeTest_STRING and an
`assert(pIter->base.bEof==0)` in fts5MultiIterNext. In 3.54.1 both are already
absent/present as pre-fix in that spot (the check is missing, the assert exists),
so reversing them is a no-op. The bug is masked because `fts5ExprNearInitAll`
(ext/fts5/fts5_expr.c) marks the node EOF as soon as *any* term of any phrase
matches no rows, so fts5ExprNodeTest_STRING never sees an EOF iterator.

## Change
`fts5ExprNearInitAll`: `if( bHit==0 )` -> `if( bHit==0 && j==0 )`. Only a
phrase whose first token matches nothing makes the node EOF; a later token with
zero rows leaves an EOF iterator in a live node (the situation the fix's
commit message describes: first token matches, another matches zero).
fts5ExprNodeTest_STRING then calls fts5ExprAdvanceto on the EOF iterator,
reaching fts5MultiIterNext, which the fix's assert (still present) catches.

## Oracle failure
fts5simple3-4.6 (`SELECT * FROM t2('ab + xyz')`) aborts with
`Assertion pIter->base.bEof==0 failed` in fts5MultiIterNext.
