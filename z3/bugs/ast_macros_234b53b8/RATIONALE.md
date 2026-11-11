# Rationale

1. src/ast/macros/macro_manager.cpp (macro_expander_cfg): FIX.diff replaced `SASSERT(v->get_idx() < num)` by `if (v->get_idx() >= num) return false;`. Restored the SASSERT.
2. src/tactic/arith/fix_dl_var_tactic.cpp: FIX.diff removed the seq_util member and the seq-aware `is_uninterp` (treating seq terms as non-arith-uninterpreted) so the global is_uninterp (null family only) is used. Re-added the member, include, and the local is_uninterp, so seq terms count as uninterpreted and fix_dl_var wrongly fixes variables -> 3028 tests give sat instead of unsat.

The remaining hunks of FIX.diff (SASSERT(false) removal, TRACE changes) were not reintroduced (debug-only).

## Final ./check.sh output
BUILD OK
FAIL z3test:smt2/3028.smt2 (rc=0)
    1c1
    < sat
    ---
    > unsat
FAIL z3test:smt2/issue-3028.smt2 (rc=0)
    1c1
    < sat
    ---
    > unsat
