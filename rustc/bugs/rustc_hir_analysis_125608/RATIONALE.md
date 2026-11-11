# Adapted injection for Mark all extraneous generic args as errors

Fix: https://github.com/rust-lang/rust/commit/adb2ac01657d8c0e972d641b6d22cc9b98ae217a

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, `provided_kind` in the generic-args lowering context (lower_generic_args_of_path).
Removed the early return `if let Err(incorrect) = self.incorrect_args { if incorrect.invalid_args.contains(&param.index) { return param.to_error(tcx) } }`.
This re-expresses fix hunk `@@ -442,6 +442,25 @@ impl<'tcx> dyn HirTyLowerer<'tcx> + '_` which added that check (error region/ty/const) at the top of provided_kind. Without it, extraneous generic args are lowered normally rather than marked as errors. `inferred_kind` check kept (it predates the fix).
