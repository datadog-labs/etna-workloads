# Rationale

Fix hunk reversed: `ConstEvaluator::f_up` in
`datafusion/optimizer/src/simplify_expressions/expr_simplifier.rs`.

The fix added, in the `ConstSimplifyResult::SimplifyRuntimeError(err, expr)` arm, a check that
returns `Err(err)` when the expression is a `Cast`/`TryCast` of a literal. In 55.2.0 the same
code is still there (only rewritten as a let-chain), so I removed it. The arm is back to
`SimplifyRuntimeError(_, expr) => Ok(Transformed::yes(expr))`, which swallows the error and
leaves the cast to fail at execution time.

Oracle cases that fail (the error is no longer wrapped in
"Optimizer rule 'simplify_expressions' failed"):
- select.slt: `SELECT CAST('' AS int)` now gives a bare "Cannot cast string ''" error.
- struct.slt: the `row()` with incorrect order case now gives "While casting struct field 'c'..."
  without the optimizer wrapper.

The other oracle files (arrow_typeof, cte, errors, map, nullif) were not reported as failing by
`check.sh`. The cases that fail are the ones listed above.
