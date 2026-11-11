# Rationale
Changed hunk: src/src/ast/rewriter/arith_rewriter.cpp, mk_to_int_core. Removed the block that, for an add whose
args mix integer numerals / to_real terms with other real terms, splits it into
`(+ ints (to_int (+ reals)))` (BR_REWRITE3).
Traces to the FIX.diff hunk that introduced this split ("strengthen simplification of to_int"). Without it, to_int is
only eliminated when all args are int numerals/to_real (the pre-fix behaviour), so #1608 is no longer solved in
pre-processing and z3 times out on issue-1608.smt2 instead of printing unsat.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/issue-1608.smt2 (rc=137)   (timeout; expected "unsat" missing)
