# Rationale

Fix hunk reversed: in `CaseExpr::case_column_or_null` (`datafusion/physical-expr/src/expressions/case.rs`),
the fix replaced `not(bit_mask)?` with a match that calls `prep_null_mask_filter` first when the
predicate array has nulls. In 55.2.0 the code is the same match (around line 1130); I reverted it to the
pre-fix `let bit_mask = not(bit_mask)?;`.

Why equivalent: with a nullable WHEN predicate, `not` leaves nulls as null, so `nullif(&array, &bit_mask)`
does not null out rows where the predicate is NULL. Those rows keep the THEN value instead of becoming NULL.

Other paths (`expr_or_expr`, `case_when_no_expr`, etc.) already use `prep_null_mask_filter` and were not touched.

Oracle: `case.slt` "column or implicit null" queries, where the WHEN predicate has NULLs, should return
THEN values (e.g. 7) in rows that should be NULL. The new unit test
`test_when_null_and_some_cond_else_null` would also fail.
