# Adapted injection for Infer async closure args from Fn bound even if there is no corresponding Future bound

Fix: https://github.com/rust-lang/rust/commit/4290943fb35b1e0472d6ee4888c5ab106abe1311

# Hunk: compiler/rustc_hir_typeck/src/closure.rs, extract_sig_from_projection_and_future_bound
Re-expresses fix hunk `@@ -564,24 +568,43 @@` (the `return_ty.unwrap_or_else(|| self.next_ty_var(..))` fallback with fresh var). 
Buggy behaviour restored: if no `Future<Output = ..>` bound is found on the return vid, the function returns None (`let return_ty = return_ty?;`) instead of providing an expected sig with a fresh output var, so async closure args aren't inferred from a bare `Fn` bound.
