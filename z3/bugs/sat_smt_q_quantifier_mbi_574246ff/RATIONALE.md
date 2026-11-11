Changed hunk: src/src/sat/smt/q_mbi.cpp (solver_project), traces to the q_mbi.cpp hunk of FIX.diff.
The fix moved the "is_true in model" check to after eliminate_nested_vars and over all fmls
(domain_eqs plus the eliminated-nested-var formulas). I restored the old behaviour: check only
qb.domain_eqs, before eliminate_nested_vars. Formulas produced by elimination are then never
checked, so false literals reach mbp extract_literals (assertion violation in mbp_plugin.cpp:197)
on issues/5420.smt2.
The model_evaluator.cpp hunk only changes trace output, so it was not reverted.
Final check.sh: z3test:issues/5420.smt2 FAIL (output shows ASSERTION VIOLATION instead of expected sat/unsat).
