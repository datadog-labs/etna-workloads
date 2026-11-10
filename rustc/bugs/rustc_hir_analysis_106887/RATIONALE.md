# Adapted injection for Make const/fn return params more suggestable

Fix: https://github.com/rust-lang/rust/commit/0b5941aa1117b6054a6e991787e8075adf392b11

# Hunk: compiler/rustc_hir_analysis/src/collect.rs, `infer_return_ty_for_fn_sig`
Replaced `if let Some(suggestable_ret_ty) = ret_ty.make_suggestable(tcx, false, None)` with
`if ret_ty.is_suggestable(tcx, false) { let suggestable_ret_ty = ret_ty; ...`.

Re-expresses fix hunk `@@ -1199,28 +1199,22 @@ fn infer_return_ty_for_fn_sig`:
`-            if ret_ty.is_suggestable(tcx, false) {` / `+            if let Some(ret_ty) = ret_ty.make_suggestable(tcx, false) {`.
Before the fix, a return type containing a FnDef (e.g. `Wrapper<fn item>`) was not "suggestable", so no
`fn()` pointer suggestion was made for `fn bar() -> _ { Wrapper(foo) }`.
