# Rationale

Fix hunk (src/trigger.c, triggerStepAllocate): added `if( pParse->nErr ) return 0;`
so no TriggerStep is allocated after a syntax error.

In 3.54.1 the same guard is written as `if( pParse->nErr==0 ){ ... }` wrapping the
allocation body. I replaced that condition with a bare block `{` (src/trigger.c:484),
so allocation proceeds even when the parser has already reported an error. This is
the pre-fix behaviour. The qualified-name check and the rest of the body are unchanged.

## Oracle failure
trigger1-23.1 (`INSERT INTO t1 SELECT e_master LIMIT 1,#1;` in a trigger) aborts with
`dupedExprStructSize: Assertion 'p->pRight==0' failed`. This is the Expr-invariant
violation the fix guards against. All other trigger1 cases pass.
