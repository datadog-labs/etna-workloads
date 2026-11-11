# Adapted injection for account for safe target features in fndef<->closure and fndef<->fndef coerce-lubs

Fix: https://github.com/rust-lang/rust/commit/76bd21ad6644dddfabe8720340d18ad829745d07

# Rationale
File: compiler/rustc_hir_typeck/src/coercion.rs, fn `FnCtxt::sig_for_coerce_lub` (FnDef arm).

Re-expresses the fix hunk `@@ -1137,6 +1060,94 @@` (adds `sig_for_coerce_lub` -> `sig_for_fn_def_coercion(ty, None)`)
and the removal in coerce_lub of the old code `(Some(prev_ty.fn_sig(self.tcx)), Some(new_ty.fn_sig(self.tcx)))`
plus the up-front `is_force_inline` check. The FnDef arm now returns the plain `ty.fn_sig()` (after the force-inline check),
skipping `adjust_target_feature_sig`, so safe-target-feature fns are not treated as safe when lubbed (the pre-fix behaviour).
