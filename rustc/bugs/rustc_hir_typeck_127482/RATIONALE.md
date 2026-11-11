# Adapted injection for Infer async closure signature from old-style two-part Fn + Future bounds

Fix: https://github.com/rust-lang/rust/commit/f4f678f27e84254cc89fd53ae20e467a254982de

Changes in compiler/rustc_hir_typeck/src/closure.rs:

1. `deduce_sig_from_projection`: removed the third match arm (async closure + `FnOnceOutput` projection -> `extract_sig_from_projection_and_future_bound`). Re-expresses the fix hunk `@@ -470,14 +471,37 @@` which added the "out-of-fashion `F: FnOnce() -> Fut, Fut: Future<Output = T>`" arm. Without it, the match returns `None` for those bounds, so no signature is inferred. The helper is left in place with `#[allow(dead_code)]` (fix hunk `@@ -500,6 +523,69 @@`).
2. `deduce_closure_signature_from_predicates`: async closure kind deduction no longer falls back to `fn_trait_kind_from_def_id` (removes `.or_else(|| self.tcx.fn_trait_kind_from_def_id(trait_def_id))`). Re-expresses fix hunk `@@ -424,9 +424,10 @@`.
