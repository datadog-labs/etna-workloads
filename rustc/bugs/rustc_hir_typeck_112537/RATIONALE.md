# Adapted injection for Don't record adjustments twice in note_source_of_type_mismatch_constraint

Fix: https://github.com/rust-lang/rust/commit/696cd98e6b51d657247cd61ee1babcf0ee4b9a8a

# Rationale
File: compiler/rustc_hir_typeck/src/method/confirm.rs, fn adjust_self_ty (ConfirmContext).
Removed the `if !self.skip_record_for_diagnostics { ... }` guard around `self.apply_adjustments(self.self_expr, adjustments);`.
Re-expresses fix hunk `@@ -219,7 +234,9 @@ impl<'a, 'tcx> ConfirmContext<'a, 'tcx>` (`if !self.skip_record_for_diagnostics { self.apply_adjustments(...) }`).
Diagnostic-only method lookups now record adjustments on the receiver again, so adjustments get recorded twice.
