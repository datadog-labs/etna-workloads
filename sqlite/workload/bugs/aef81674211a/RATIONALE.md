# Rationale

Fix hunk (src/expr.c, impliesNotNullRow, TK_AND): replaced an unconditional
`assert(eCode==0)` with an `if( pWalker->eCode==0 )` guard around the
left/right walk.

In 3.54.1 that logic lives in the helper `bothImplyNotNullRow()` (shared by
TK_AND/TK_OR and TK_BETWEEN). I removed its `if( pWalker->eCode==0 )` guard
and restored `assert( pWalker->eCode==0 );`, the pre-fix form. The TK_AND
case reaches the code only through this helper, so this is the same defect.
TK_BETWEEN also goes through the helper and gets the same pre-fix behaviour.

Effect: when an AND is nested inside a comparison whose left operand already
set eCode=1, the stale eCode is treated as "left arm implies non-null". In
release builds that can produce a false positive. In debug builds the assert fires.

Oracle: test/expr.test expr-16.102 aborts with
`bothImplyNotNullRow: Assertion 'pWalker->eCode==0' failed`. The remaining
expr-16.x cases (including 16.101) were not reached or did not fail.
