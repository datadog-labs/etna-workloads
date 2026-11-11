Hunk traced: FIX.diff purify_arith_tactic.cpp mk_def_proof (the only behavioural hunk; TRACE and include hunks are cosmetic).
Restored the buggy argument order: mk_eq(k, def) and mk_apply_def(k, def, pr1) instead of (def, k). With proofs enabled the
def-intro proof has the wrong orientation, tripping an assertion in rewriter_def.h (st == BR_FAILED || rewrites_to(m_r, m_pr2)) on smt2/3155.smt2.
check.sh: z3test:smt2/3155.smt2 FAIL (expected "sat", got ASSERTION VIOLATION).
