# Rationale

In 55.2.0 `comparison_coercion_numeric` no longer exists. The numeric and general
comparison coercions were merged into `comparison_coercion`
(`datafusion/expr-common/src/type_coercion/binary.rs`), and the fix's helper
`dictionary_comparison_coercion_generic` became `dictionary_coercion`. So the fix's
hunks do not apply, and reversing them is a no-op.

Change: removed the `.or_else(|| dictionary_coercion(lhs_type, rhs_type, true, comparison_coercion))`
step from `comparison_coercion`. This reverses the fix's added
`.or_else(|| dictionary_comparison_coercion_numeric(...))` step: the
comparison chain once again has no dictionary handling, which is the pre-fix state of
`comparison_coercion_numeric`. The refactor hunk (extracting the generic helper) is
not behavioural and was left alone.

Caveat: this is broader than the original bug, because `comparison_coercion` is also
used by binary operators. Dictionary comparisons there are now also affected, where
before the fix only the numeric variant was.

Oracle: `nullif.slt` fails. `NULLIF(dict, 'bar')` and `NULLIF(col2, dict)` raise
"For function 'nullif' Dictionary(Int32, Utf8) and Utf8 is not comparable", the error
quoted in the fix's test comment.
