# Adapted injection for Fix a error suggestion for E0121 when using placeholder _ as return types on function signature.

Fix: https://github.com/rust-lang/rust/commit/50edb32939898fa6c22f3e2b2596317a031acaa7

# Rationale
File: compiler/rustc_hir_analysis/src/collect.rs, fn `recover_infer_ret_ty` (formerly `infer_return_ty_for_fn_sig`).
Re-expresses the single fix hunk `@@ -1459,8 +1459,25 @@ fn infer_return_ty_for_fn_sig`: the fix added `has_region_params`
and mapped `ty::ReErased` to `Region::new_error_with_message(...)` when the generics have lifetime params
(else `re_static`). I removed that, restoring the parent behaviour: `ty::ReErased => tcx.lifetimes.re_static` always.
Result: the E0121 suggestion for `-> _` is wrong with lifetime params (`S<'static>` instead of `S<'_>`).
