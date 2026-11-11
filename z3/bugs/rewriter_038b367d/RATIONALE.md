Changed src/src/ast/rewriter/arith_rewriter.cpp (mk_mod_core), two hunks of FIX.diff:
1. Removed the symbolic-modulus block that drops summands equal to y or k*y from mod(a+k*y, y) (FIX.diff hunk 2). Without it mod(a+y,y) is not reduced to mod(a,y).
2. Restored the numeral-only idempotency rule (hunk 1), removing the ite(y=0,...) rewrite for symbolic y.
Final check.sh result:
FAIL arith_rewriter (rc=114)
