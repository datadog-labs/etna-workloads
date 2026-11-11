Changed hunk: src/src/solver/assertions/asserted_formulas.cpp, asserted_formulas::reduce():
`if (!m_has_quantifiers && !m_smt_params.m_preprocess) return;` -> `if (!m_smt_params.m_preprocess) return;`
Traces to the first hunk of FIX.diff (smt/asserted_formulas.cpp, file now in solver/assertions). Without the m_has_quantifiers check, reduce() skips preprocessing even with quantifiers when preprocess is off, as in #3591.
The reduce_assertions return-type hunks are refactoring and not reintroduced.

check.sh output: BUILD OK; FAIL z3test:smt2/3591.smt2 (rc=0): expected sat, got unknown.
