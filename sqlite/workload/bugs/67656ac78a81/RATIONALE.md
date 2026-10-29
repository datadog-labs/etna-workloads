# Rationale

Bug: the term driving an index is disabled (`disableTerm`) even when it is a
transitive constraint (derived via equivalence, `WO_EQUIV`), which yields wrong
results (forum post eb8613976a).

## Change

`src/wherecode.c`, `codeEqualityTerm()`: the fix hunk wrapped `disableTerm()` in
`if( (wsFlags & WHERE_TRANSCONS)==0 || (pTerm->eOperator & WO_EQUIV)==0 )`.
I restored the pre-fix unconditional `disableTerm(pLevel, pTerm);`.

The `WHERE_TRANSCONS` definition (whereInt.h) and the places that set it in
where.c (two sites; the fix only had one) are left in place; they are now
unused flag-setting, which is harmless. Only the consumer was reverted.

## Oracle failures (test/transitive1.test)

- transitive1-620: `likely(b1=z3) AND a0=z3` returns a row instead of empty.
- transitive1-630: the NATURAL JOIN / likely() queries return rows instead of empty.
- transitive1-720: returns `1 1 2 2 2 3` instead of empty.
