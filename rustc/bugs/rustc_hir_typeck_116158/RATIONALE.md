# Adapted injection for Don't suggest nonsense suggestions for unconstrained type vars in note_source_of_type_mismatch_constraint

Fix: https://github.com/rust-lang/rust/commit/ac5aa8c1a4370b34674d18ef20b642645d2172e0

compiler/rustc_hir_typeck/src/demand.rs, `note_source_of_type_mismatch_constraint`: removed the `&& !ideal_arg_ty.has_non_region_infer()` guard (with `let ideal_arg_ty = self.resolve_vars_if_possible(...)`) before `emit_type_mismatch_suggestions`. This re-expresses the fix hunk `@@ -504,12 +504,18 @@` which added `&& !ideal_arg_ty.has_non_region_infer()`. Without it, nonsense suggestions are emitted for unconstrained type vars (#116155).
