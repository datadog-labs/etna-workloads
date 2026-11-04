# Rationale

Hunk changed: `datafusion/sql/src/expr/mod.rs` (the only implementation hunk in fix.patch).

The code still lives in the same place in 55.2.0. I reversed the fix:
- `SQLExpr::Floor` / `SQLExpr::Ceil` again bind `field: _field` and call `sql_fn_name_to_expr(.., "floor"/"ceil", ..)` unconditionally, so the `CeilFloorKind` (Scale / DateTimeField) is silently ignored.
- Removed the now-unused `CeilFloorKind` and `DateTimeField` imports (restoring the pre-fix import list).

Oracle (`scalar.slt`) failures:
- `select ceil(100.1234, 1)` expected a "CEIL with scale is not supported" error but succeeds.
- `select ceil(100.1234 to year)` expected an error but succeeds.
- `select floor(a, 1)` / `select floor(a to year)` get a schema error ("No field named a") instead of the not-implemented error.
