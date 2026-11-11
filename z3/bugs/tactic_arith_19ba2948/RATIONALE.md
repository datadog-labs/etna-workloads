Changed hunk: src/src/tactic/arith/fix_dl_var_tactic.cpp, added is_target::is_uninterp(expr*) that returns
`is_app(n) && family_id != arith family`.

Traces to FIX.diff hunk "is_uninterp": the fix made is_uninterp exclude the seq family as well
("sequence theory is not disjoint from arithmetic"). In today's code is_uninterp resolves to the global
null-family check, which rejects seq terms. Re-adding the local arith-only version treats seq terms as
uninterpreted, so fix-dl-var wrongly fixes a variable at zero when it occurs under sequence ops.
This is the bug of #3023: result is wrong (unknown instead of unsat on issue-3023.smt2).
The other FIX.diff hunks (seq_util member, process_app loop, trace) are refactors/cosmetic and were not reverted.

check.sh output:
BUILD OK
FAIL z3test:smt2/issue-3023.smt2 (rc=0)
    1c1
    < unknown
    ---
    > unsat
