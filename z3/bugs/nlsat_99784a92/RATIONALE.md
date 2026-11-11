# Rationale

One hunk changed: src/src/nlsat/tactic/nlsat_tactic.cpp, `nlsat_tactic::imp::eval_model`.
Traces to the FIX.diff hunk in nlsat_tactic.cpp `eval_model`, which changed
`if (!model.is_true(g.form(i)))` to `if (model.is_false(g.form(i)))`. I undid it.
With the old condition, any goal formula the model does not evaluate to exactly true
(e.g. a partially evaluated term such as `(^ (/ 3.0 8.0) 210.0)` with an algebraic or
unevaluated subterm) is reported as a failed model check. eval_model then prints the
formula and model through IF_VERBOSE(0, ...), which is the stray output the z3test
expected-output comparison catches. This is the pre-fix behaviour for #3225.

The other hunks of FIX.diff were not reintroduced. Most are trace-only or cosmetic.
The nlsat_solver.cpp ones (the `sz == 0` block in `mk_ineq_literal` and the zero-polynomial
handling in substitute_var, now in nlsat_simplify.cpp) were tried and did not make any
oracle unit fail, so I dropped them to keep the change minimal.

## ./check.sh output
BUILD OK
FAIL z3test:smt2/3225.smt2 (rc=0)
    0a1,3
    > (= (* k!0 (^ (/ 3.0 8.0) 210.0)) 40.0) -> (= (^ (/ 3.0 8.0) 210.0)
    >    (/ 15684240429131529254685698284890751184639406145730291592802676915731672495230992603635422093849215049.0
    >       4455508415646675018204269146191690746966043464109921807206242693261010905477224010259680479802120507596330380442963288389344438204468201170168614570041224793214838549179946240315306828365824.0))
FAIL z3test:smt2/issue-3225.smt2 (rc=0)
    0a1,3
    > (= (* k!0 (^ (/ 3.0 8.0) 210.0)) 40.0) -> (= (^ (/ 3.0 8.0) 210.0)
    >    (/ 15684240429131529254685698284890751184639406145730291592802676915731672495230992603635422093849215049.0
    >       4455508415646675018204269146191690746966043464109921807206242693261010905477224010259680479802120507596330380442963288389344438204468201170168614570041224793214838549179946240315306828365824.0))
