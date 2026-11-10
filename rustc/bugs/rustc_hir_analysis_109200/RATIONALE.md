# Adapted injection for Fix index out of bounds in suggest_trait_fn_ty_for_impl_fn_infer

Fix: https://github.com/rust-lang/rust/commit/60da5de1c68e8465f4896f8cd5a8b158c00051a1

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs (moved from astconv/mod.rs), fn suggest_trait_fn_ty_for_impl_fn_infer.
Re-expresses hunk `@@ -3317,10 +3317,13 @@`: restores pre-fix code using `fn_sig.input(arg_idx)` (panics with index out of bounds when impl fn has more params than trait fn) and liberating regions on the single type, instead of `*fn_sig.inputs().get(arg_idx)?`.
