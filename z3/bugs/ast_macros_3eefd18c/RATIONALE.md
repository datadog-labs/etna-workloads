Changed src/src/ast/macros/quasi_macros.cpp (both apply_macros overloads), tracing to the quasi_macros.cpp hunks of FIX.diff.
The fix keeps the rewriter's proof (`m_rewriter(r, rr, prr)` then `mk_modus_ponens(pr, prr)`). I reverted to `m_rewriter(r)`, which discards the rewrite proof. The resulting proof's fact no longer equals the rewritten formula.
With proofs on, goal::assert_expr then hits `SASSERT(f == m().get_fact(pr))`. z3test smt2/3688.smt2 fails with that assertion violation.
The FIX.diff signature refactor and the SASSERT additions were not reverted.
Final ./check.sh: BUILD OK; FAIL z3test:smt2/3688.smt2 (rc=110, assertion violation at goal.cpp:257 f == m().get_fact(pr))
