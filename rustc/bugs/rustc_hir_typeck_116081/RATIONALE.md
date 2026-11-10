# Adapted injection for Check that closure's by-value captures are sized

Fix: https://github.com/rust-lang/rust/commit/c21867f9f6af92c4669b1ee7541291d7b9635b1a

# Rationale
File: compiler/rustc_hir_typeck/src/upvar.rs, fn closure_analyze/analyze_closure (just after `debug!(?closure_hir_id, ?args, ?final_upvar_tys);`).
Removed the block `if self.tcx.features().unsized_fn_params() { for capture in closure_min_captures_flattened { if ByValue { require_type_is_sized(..., ObligationCauseCode::SizedClosureCapture(closure_def_id)) } } }`.
Re-expresses fix hunk `@@ -295,6 +296,20 @@ impl<'a, 'tcx> FnCtxt` (the added `require_type_is_sized` loop). Other hunks (enum variant, error note) only support the diagnostics and are left in place (harmless).
