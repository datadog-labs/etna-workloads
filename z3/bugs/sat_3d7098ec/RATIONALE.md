# Rationale

Changed hunk: src/src/sat/smt/atom2bool_var.cpp, `atom2bool_var::mk_var_inv`:
removed `var2expr.reserve(kv.m_value + 1);` before `var2expr.set(...)`.

Traces to the FIX.diff hunk in atom2bool_var.cpp, which added exactly that reserve
(file has moved from sat/tactic/ to sat/smt/ and the vector type is now expr_ref_vector).
Without the reserve, `set` indexes past the vector's size when the model is built
(inc_sat_solver get_model_core iterates over var2expr from mk_var_inv), the bug in #3137.
Other FIX.diff hunks are trace/cleanup only and were not touched.

## ./check.sh output
BUILD OK
FAIL z3test:smt2/3137.smt2 (rc=110)
    1a2,6
    > ASSERTION VIOLATION
    > File: .../src/util/vector.h
    > Line: 364
    > idx < size()
