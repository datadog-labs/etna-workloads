# Adapted injection for Fix unwrap suggestion for async fn

Fix: https://github.com/rust-lang/rust/commit/23341434bdfdecf882b886146e6a25a9a15f09d9

# Hunk: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, `suggest_missing_unwrap_expect`
The `ret_ty_matches` closure now reads the return type from `self.ret_coercion` expected type
instead of the fn signature (`self.fn_sig()`, 1.99.1's equivalent of `body_fn_sig()`).
Re-expresses fix hunk `@@ -1747,19 +1747,17 @@`, which replaced the `ret_coercion ... expected_ty()` lookup
with `let Some(sig) = self.body_fn_sig() ... sig.output().kind()`.
For async fns the coercion type is the inner type (`i32`), not `impl Future`, so the `?` suggestion goes wrong.
