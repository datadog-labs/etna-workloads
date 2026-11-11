# Adapted injection for Suggest adding `return` if the type of unused semi return value can coerce to the fn return type

Fix: https://github.com/rust-lang/rust/commit/25d38c48c3c7d06c14ae65e964a114b89c09756e

Upstream later removed the MaybeForgetReturn suggestion (commit 9323ba54d3b), so 1.99.1 lacks it entirely; re-injection re-adds the feature (the "bug" = extra suggestion in the test's stderr).

- rustc_errors/src/lib.rs, `enum StashKey`: add `MaybeForgetReturn` (fix hunk `@@ -507,6 +507,7 @@ pub enum StashKey`).
- rustc_trait_selection/src/error_reporting/traits/ambiguity.rs (Sized ambiguity branch): E0282 is stashed with `StashKey::MaybeForgetReturn` instead of emitted (fix hunk in type_err_ctxt_ext.rs `err.stash(span, StashKey::MaybeForgetReturn)`), plus import.
- rustc_hir_typeck/src/fn_ctxt/_impl.rs `report_ambiguity_errors`: collect `(span, root_obligation cause code)` before reporting, then call `collect_unused_stmts_for_coerce_return_ty` (fix hunk `@@ -564,7 +564,12 @@` `errors_causecode`).
- rustc_hir_typeck/src/fn_ctxt/checks.rs: new `collect_unused_stmts_for_coerce_return_ty` (fix hunk `@@ -1845,6 +1849,55 @@`), steals the stashed diag, walks parents for a `Semi` stmt whose type coerces to the return type, adds "you might have meant to return this to infer its type parameters" suggestion. Adapted: ExprBindingObligation -> WhereClauseInExpr, steal_diagnostic -> try_steal_modify_and_emit_err, can_coerce -> may_coerce, StashKey import.
