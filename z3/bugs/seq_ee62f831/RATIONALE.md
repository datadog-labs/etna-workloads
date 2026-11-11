Changed hunks (all trace to FIX.diff implementation hunks):

1. src/src/ast/rewriter/seq_rewriter.cpp, mk_app_core: removed `case OP_STRING_LT` -> mk_str_lt dispatch
   (FIX.diff hunk 1). String `<` is no longer simplified by the rewriter, as before the fix.
2. seq_rewriter.cpp, mk_str_le: `BR_REWRITE2` -> `BR_DONE` (FIX.diff hunk 3). The produced `not (str.< b a)` is no longer re-simplified.
   (mk_str_lt itself / header hunks left in place; they are now dead code, which is harmless.)
3. src/src/ast/seq/seq_axioms.cpp, axioms::lt_axiom (moved from theory_seq.cpp): restored the pre-fix
   axioms using emp1/emp2 instead of prefix(e1,e2)/prefix(e2,e1) (FIX.diff theory_seq.cpp hunk).
   Doc comment left as is.

Together these reproduce the #2892 wrong answer: `(str.<= "7" (str.++ "7" "f"))` yields unsat instead of sat.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/2892.smt2 (rc=0)
    1c1
    < sat
    ---
    > unsat
