# Adapted injection for Fix ICE when Self is used in enum discriminant of a generic enum

Fix: https://github.com/rust-lang/rust/commit/aacac7e2e372740307b61343fecdf23b6da77606

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `check_param_uses_if_mcg`.
Re-expresses the last hunk of fix.diff (`@@ -460,37 +482,80 @@`, the hunk that replaces
`if tcx.def_kind(parent_def_id) == DefKind::AnonConst && let ty::AnonConstKind::MCG = tcx.anon_const_kind(parent_def_id)`
with `if let Some(context) = self.anon_const_forbids_generic_params()`).
Buggy behaviour restored: the check is gated only on a directly-MCG anon const, so enum discriminant anon consts
(and nested inline consts/closures) bypass the folder, and `Self` aliasing a generic type reaches const_eval_poly (ICE/TooGeneric span_bug).
The helper `anon_const_forbids_generic_params` is left in place (used by the other call site) but no longer wired into this function.
