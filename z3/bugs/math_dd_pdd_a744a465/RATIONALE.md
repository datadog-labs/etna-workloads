# Rationale

Changed hunk (src/src/math/dd/dd_pdd.cpp, apply_rec, pdd_sub_op branch `is_val(q) || level_p > level_q`):
`apply_rec(lo(p), q, op)` -> `apply_rec(q, lo(p), op)`.

Traces to FIX.diff hunk `@@ -144,12 +146,18 @@` in dd_pdd.cpp, which changed
`push(apply_rec(b, lo(a), op))` to `push(apply_rec(lo(a), b, op))` in the `is_val(b)` case.
The bug is swapped operands for a non-commutative subtraction: (ax+b) - k became k - b instead of b - k,
so the constant term has the wrong sign/value. In today's code the same case lives in the pdd_sub_op branch.
The other fix hunks (spoly, common_factors, display, etc.) are not needed to trigger a test failure and were left alone.

Final ./check.sh output: pdd unit FAILS (ASSERTION VIOLATION src/test/pdd.cpp line 141, `e == f`); build OK.
