# Rationale

Fix hunk reversed: `Expr::metadata` gained `Expr::Cast(Cast { expr, .. }) => expr.metadata(schema)`,
so a cast preserves its input's field metadata. In 55.2.0 `metadata()` is computed via `to_field()`,
and for `Expr::Cast` that goes through `cast_output_field` (datafusion/expr/src/expr_schema.rs).
For a type-only cast, it copies the source metadata (minus extension keys).

Change: in the `is_type_only` branch of `cast_output_field`, return empty metadata instead of the
source metadata. A cast then drops its input's metadata, which is the pre-fix behaviour
("cast should drop input metadata since the type has changed"). Explicit-target-field casts are unchanged.

Oracle: metadata.slt fails in check.sh with 10 query result mismatches. For example,
`arrow_metadata(TRY_CAST(name AS INT), 'metadata_key')` returns NULL instead of `the name field`.
The same mismatch appears for CAST on `id`. The cast and distinct-with-cast cases the fix added are
among the cases that depend on cast metadata propagation.
