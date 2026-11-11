Changed hunk: src/src/smt/seq_regex.cpp, seq_regex::propagate_in_re: removed the call to unfold_complement.

Traces to the theory_seq.cpp hunk of FIX.diff (propagate_in_re: when !is_true, use re.mk_complement(e2) and treat the literal as positive). In this release that logic lives in seq_regex::unfold_complement, so removing the call undoes the fix: negated membership constraints are no longer complemented. The other FIX.diff hunks (automata refactor, determinization, ast.cpp counter) have no counterpart in this code, since the automata code is gone, and the rest are cosmetic.
Result: issue-1224.smt2 gives sat with "invalid model" instead of unsat.

check.sh output:
BUILD OK
FAIL z3test:smt2/issue-1224.smt2 (rc=1)
    1,2c1,4
    < unsat
    < unsat
    ---
    > sat
    > (error "line 5 column 10: an invalid model was generated")
    > sat
    > (error "line 11 column 10: an invalid model was generated")
