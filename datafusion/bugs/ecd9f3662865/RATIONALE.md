# Rationale

## Changed hunk
`datafusion/optimizer/src/analyzer/type_coercion.rs`, `Expr::Between` arm of
`TypeCoercionRewriter::f_up`: `high_coerced_type` is computed with
`comparison_coercion(&expr_type, &low_type)` instead of `&high_type`.

This reverses the single implementation hunk of the fix (#14007). The 55.2.0 code
has the same structure as the pre-fix code (low/high coerced types, then
combined), so the reversal is exact. The error message still mentions `high_type`,
as it did before the fix.

The fix's other hunks only changed tests, so there is nothing else to revert.

## Oracle failure
`expr.slt` fails at `select 1 where null between null and 2;`:

    Error during planning: Cannot automatically convert Int64 to Null

The high bound's type is ignored, so the coerced type is Null. Casting `2` to Null
then fails. The fix removed exactly this failure.
