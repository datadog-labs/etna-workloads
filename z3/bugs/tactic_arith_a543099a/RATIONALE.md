Changed hunk: src/src/tactic/arith/fix_dl_var_tactic.cpp, process_app.
Traces to the FIX.diff hunk in process_app that added `if (!is_uninterp(t) && !is_arith(t)) throw_failed(t);`.
Removing the check means non-arithmetic, interpreted applications (e.g. str.to.int/int.to.str under `distinct`)
no longer make the tactic fail, so it wrongly fixes a variable at zero and returns unsat instead of unknown (issue #3023).
(The process_eq restructuring hunk is behaviour-neutral; other hunks are cleanup/trace only.)

check.sh: BUILD OK; FAIL z3test:smt2/issue-3023.smt2 (got unsat, expected unknown).
