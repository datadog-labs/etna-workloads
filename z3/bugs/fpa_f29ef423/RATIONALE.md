# Rationale

Only file changed: `src/src/ast/fpa/fpa2bv_converter.cpp`, in `fpa2bv_converter::mk_to_fp_real`,
the branch for a symbolic (non-numeral) real `x`.

In this release that branch looks different from the one the fix was written against. It no longer
calls `round(...)`. The result is now built from fresh sign, exponent and significand constants,
and the rounding encoding added by the fix has been rewritten into a linear form. The bug is still
the same, though: what decides the result is the constraint that relates `x` to the result.

## Hunk 1 (FIX.diff @@ -2946,9 +2946,6 @@: removes `fp.to_real(result) = x`)
I put the exact round-trip equality back right after `result` is built, ahead of the NaN constraint,
where it sat before the fix:

    expr * e = m.mk_eq(m_util.mk_to_real(result), x);
    m_extra_assertions.push_back(e);

This makes every conversion of a symbolic real exact. Any query whose models need inexact rounding
becomes a false `unsat`. That is the reported bug (#10881).

## Hunk 2 (FIX.diff @@ -2982,6 +2979,94 @@: adds the rounding-relation block)
I deleted the whole block the fix added (in its present rewritten form), from the comment "The
conversion from a symbolic real is inexact in general..." through the sign constraints. That covers
the neighbor gaps, the nearest and directed rounding conditions, toward-zero saturation and the
`x>0 -> sgn=0` / `x<0 -> sgn=1` constraints. With it gone, only the pre-fix constraints are left:
exact equality, not NaN, overflow to infinity, and `x = 0 -> +0`.

## Result
The `fpa` unit fails. The first assertion to fail is in `test_incremental_symbolic_to_fp_real`.
With `q = 1/3` and RTZ, the check gives `unsat` instead of `sat`, because 1/3 cannot be
represented exactly. That is the same false-unsat bug. Since this test stops the unit,
`test_inexact_symbolic_to_fp_real`, which runs later, never gets to run.

Final ./check.sh output (tail):

```
BUILD OK
FAIL fpa (rc=114)
    (check-sat-assuming ((= rm RNE) (= q 1.0) (not (fp.eq r ((_ to_fp 8 24) RNE 1.0)))))
    (push)
    (assert (= rm RTZ))
    (assert (= q (/ 1.0 3.0)))
    (assert (= r ((_ to_fp 8 24) RTZ (/ 1.0 3.0))))
    (check-sat)
    
    unknown
    unknown
    unsat
    ASSERTION VIOLATION
    File: <z3-src>/src/test/fpa.cpp
    Line: 347
    Failed to verify: response == "unsat\nunsat\nsat\n"
    
```
