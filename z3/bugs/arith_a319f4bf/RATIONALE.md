Both edits are in src/src/ast/rewriter/arith_rewriter.cpp (mk_power_core) and trace to the arith_rewriter.cpp hunk of FIX.diff.
The fix changed the value of x^(-y) at x=0 from 1 to 0 in the ite(x=0, c, (1/x)^(-y)) rewrite. The solve_eqs TRACE hunk is debug output only and was not reintroduced.
Today's code has two copies of that rewrite: the general y<0 branch and the y == -1 special case. I changed the constant from 0 back to 1 in both.
1. y<0 branch, ite(arg1=0, 1, ...): the same lines the fix touched.
2. y==-1 branch, ite(arg1=0, 1, ...): the test 3104.smt2 uses x^-1, so only this branch exercises it. With x=0 the rewriter says x^-1 = 1, while the model evaluates 1/x as 0, so model validation fails ("invalid model").
Final ./check.sh: BUILD OK; FAIL z3test:smt2/3104.smt2 (rc=1): expected output differs by an extra (error "line 5 column 10: an invalid model was generated").
