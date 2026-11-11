# Rationale

Only hunk changed: src/src/ast/simplifiers/solve_eqs.cpp, `if (m_config.m_context_solve && !proofs_enabled())` -> `if (m_config.m_context_solve)`.

Traces to the last two hunks of FIX.diff (solve_eqs_tactic.cpp, `if (!m_produce_proofs && m_context_solve)` guarding
distribute_and_or / collect_hoist). The tactic was rewritten into ast/simplifiers/solve_eqs.cpp, where the equivalent
guard is this one. Removing it re-enables context solving with proofs on, the original #3223 bug: it hits an assertion
violation in expr_substitution.cpp:70 on smt2/3223.smt2 instead of printing `sat`.

The other FIX.diff hunks (pr = nullptr, variable scoping, trace/dead code) have no counterpart in the rewritten code; I left them.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/3223.smt2 (rc=110)
    < sat  /  > ASSERTION VIOLATION expr_substitution.cpp Line 70
