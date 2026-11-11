# Rationale
Single hunk in src/src/ast/fpa/fpa2bv_converter.cpp (mk_to_fp_real, symbolic branch), tracing to the implementation hunk
of FIX.diff at old line ~3082. Today's code asserts `x = 0 -> result = +0`; I restored the old vacuous
`x = 0 -> (result = +0 or result = -0)`, so the solver may pick -0 for real 0 (invalid model, #7431).
(The unrelated `gt`/`lt` refactor hunk is behaviour-neutral and was not touched.)
The fpa unit now FAILS (see check.sh output: FAIL for fpa).
    unsat
    sat
    unsat
    sat
    unsat
    sat
    unsat
    sat
    unsat
    sat
    ASSERTION VIOLATION
    File: <z3-src>/src/test/fpa.cpp
    Line: 367
    Failed to verify: response == expected
    
