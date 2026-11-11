Changed src/src/muz/base/dl_rule.h and dl_rule.cpp, reverting all hunks of FIX.diff:
- dl_rule.h quantifier_finder_proc: removed m_lambda; `case lambda_k` is UNREACHABLE() again (the original bug: a lambda in a rule tail hits UNREACHABLE).
- dl_rule.h/.cpp has_quantifiers(r, exist, univ, lam) -> 2-bool-out signature; has_quantifiers(r) ignores lambdas.
Result: z3test:smt2/3775.smt2 FAILS (rc=110, UNEXPECTED CODE WAS REACHED at dl_rule.h:87).

Final ./check.sh output:
FAIL z3test:smt2/3775.smt2 (rc=110)
