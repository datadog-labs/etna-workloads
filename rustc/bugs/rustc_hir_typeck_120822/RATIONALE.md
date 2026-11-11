# Adapted injection for Emit more specific diagnostics when enums fail to cast with `as`

Fix: https://github.com/rust-lang/rust/commit/6e37f955e57454d25ef590b5215a6f20cecb9e2e

# Rationale
File: compiler/rustc_hir_typeck/src/cast.rs, `CastCheck::report_cast_error` (NonScalar arm).
Re-expresses the fix hunk `@@ -448,13 +448,35 @@ impl<'a, 'tcx> CastCheck<'tcx>`: removes the `let (msg, note) = if let ty::Adt(adt,_) = self.expr_ty.kind() && adt.is_enum() && self.cast_ty.is_numeric()` branch and the extra `err.note(note)`, restoring the single generic message "an `as` expression can only be used to convert between primitive types or to coerce to a specific trait object" for enum -> numeric casts.
