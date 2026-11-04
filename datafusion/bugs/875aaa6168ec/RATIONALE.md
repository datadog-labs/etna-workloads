# Rationale

Fix #12951: aliased `now()` caused a logical vs physical schema mismatch because
(1) `now()` was nullable and (2) `get_field_metadata` did not look through `CastExpr`,
so field metadata was lost across a cast.

## Changes
1. `datafusion/functions/src/datetime/now.rs`: `return_field_from_args` returns nullable `true`
   (reverses the `is_nullable -> false` hunk; in 55.2.0 nullability comes from `return_field_from_args`).
   By itself this is inert for the oracle (the physical-plan check only rejects physical-nullable vs logical-non-nullable).
2. `datafusion/physical-expr/src/expressions/cast.rs` (`CastExpr::resolved_target_field`, type-only cast path):
   no longer passes through the source field's metadata. This reverses the `CastExpr => recurse into cast.expr()`
   hunk in `get_field_metadata`: in 55.2.0 `get_field_metadata` is gone and metadata is derived
   via `PhysicalExpr::return_field`, so the cast's `return_field` is the equivalent place.
   The extension-type key stripping became moot and was removed along with it.

## Oracle failure
`metadata.slt` fails: e.g. `SELECT CAST(id AS TEXT) AS grp, COUNT(DISTINCT ...) GROUP BY grp` gives
"Physical input schema should be the same as the one converted from logical input schema.
field metadata ... (physical) {} vs (logical) {...}", the same class of error as the fix guards against.
`arrow_metadata(CAST(id AS BIGINT))` also loses its metadata. The new `now()` UNION ALL query was not reached/isolated
as the first failure, but the file fails.
