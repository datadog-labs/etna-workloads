# Rationale
FIX.diff hunk 1 (arith_rewriter.cpp, mk_power_core, `(^ t -k)` branch) added an
`ite(arg1 = 0, 1, result)` guard so the rewrite of x^-k stays consistent at x = 0.
In this release the same guard exists (written as ite(arg1=0, 0, result)) in two places:
the `y == -1` branch and the `y < 0` branch. I removed both guards (undoing the hunk's
effect), so `(^ t -k)` is rewritten to a plain division/power with no zero case. The
test uses exponent -1, hence the y == -1 branch had to be unguarded too.
Result: model validation fails ("an invalid model was generated").
The qe_term_graph.cpp hunk only removed a comment; no code change.

Final ./check.sh:
BUILD OK
FAIL z3test:smt2/2891.smt2 (rc=1)
    1a2
    > (error "line 3 column 10: an invalid model was generated")
