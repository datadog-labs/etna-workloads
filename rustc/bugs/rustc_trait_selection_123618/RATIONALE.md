# Adapted injection for Discard overflow obligations in impl_may_apply

Fix: https://github.com/rust-lang/rust/commit/87a387a7223a1b9d8cdc698df091383c9b703c31

One hunk: compiler/rustc_trait_selection/src/error_reporting/traits/ambiguity.rs, `compute_applicable_impls_for_diagnostics` (closure `impl_may_apply`).
Removes the `.filter(|obligation| infcx.next_trait_solver() || infcx.evaluate_obligation(obligation).is_ok())` ("throw away obligations that overflow") on the impl predicate obligations before `ocx.register_obligations`.
Re-expresses the fix hunk `@@ -52,10 +53,21 @@ pub fn compute_applicable_impls_for_diagnostics` in ambiguity.rs (which added that filter). The second fix hunk (generics_of count) was a refactor-only change and is not reproduced.
