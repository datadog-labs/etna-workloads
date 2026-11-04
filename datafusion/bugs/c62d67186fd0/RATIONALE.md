# Rationale

Fix (#17311): the `ELSE` expression was evaluated even when no rows remained for it
(`remainder.true_count() == 0`), so `case when true then 1/1 else 1/0 end` raised a
divide-by-zero error from the never-needed ELSE branch.

In 55.2.0 the `case.rs` code was rewritten (`ResultBuilder`, `remainder_batch`), and the
equivalent guard is the "all rows are true -> evaluate only THEN" shortcut in
`CaseExpr::expr_or_expr` (the single WHEN/THEN path, which is what
`CASE WHEN true THEN 1/1 ELSE 1/0 END` uses).

## Change
`datafusion/physical-expr/src/expressions/case.rs`, `CaseExpr::expr_or_expr`: removed the
`if when_value.null_count() == 0 && !when_value.has_false()` branch that returned just the
THEN value. All-true input now falls to `self.body.expr_or_expr`, which evaluates the ELSE
expression on the empty (zero-row) else batch. A constant fallible ELSE such as `1/0`
evaluates to a scalar regardless of batch size and errors, as before the fix.
This mirrors the removed `remainder.true_count() > 0` guard: ELSE evaluated with nothing left for it.

## Oracle
`case.slt`: `SELECT case when true then 1 / 1 else 1 / 0 end;` now errors with divide by zero
(the failure count in check.sh output went from 3 to 4). Note the file already had unrelated
failures at baseline (type_coercion errors around lines 821/884) in this environment.
