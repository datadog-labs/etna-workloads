# Rationale

Changed hunk: src/src/sat/smt/array_axioms.cpp, `solver::assert_select_store_axiom`.

Traces to the first hunk of FIX.diff (array_axioms.cpp), which removed the early return
`if (root(store->arg(0)) == root(select->arg(0))) return false;` ("overly permissive filter on
select_store axiom"). The line is re-added in today's code (before the `has_diff` loop). The axiom
select(store(a,i,v),j) = select(a,j) is then skipped whenever the select's array is congruent to the
store's base, which loses needed axiom instances, so the model is wrong (issue #5482).
The other FIX.diff hunks (euf_model.cpp) are only a TRACE/formatting change, with no bug effect, and were not reintroduced.

## Final ./check.sh result
Last 15 lines of its output (the PASS/FAIL line was cut off by `tail`; the diff shows failure):
```
FAIL z3test:issues/5482.smt2 (output differs from expected)
    < sat / unsat ... (expected)
    > Failed to validate b64 863: (= (store (store #665 ...) ...) ...) false
    > (sat
```
Build succeeded; the oracle unit z3test:issues/5482.smt2 now fails with a model validation failure.
