# Rationale

## src/wherecode.c, codeAllEqualityTerms()
Reverses the fix hunk that added `&& pParse->withinRJSubrtn==0` to the
`if( nReg==1 ...)` test. In 3.54.1 the `nReg==1` shortcut (release regBase and
use r1 directly, rather than OP_Copy) was no longer present, so the
unconditional OP_Copy was equivalent to the fixed code. I restored the
pre-fix shortcut: when nReg==1 and the term is coded into another register
r1, regBase becomes r1 with no copy. Inside a RIGHT JOIN subroutine, r1 may be
a register used by the body the RJ loop jumps back into (e.g. a sub-query
result), so applying index affinity to it interferes with that body.

## Oracle failures
joinH-17.2 fails: expected `0 0`, got `0` (a row is lost). 17.0/17.1 still pass.
