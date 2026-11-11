# Adapted injection for Suggest returning a reference for unsized place from a closure

Fix: https://github.com/rust-lang/rust/commit/eedf870de9bce7835ebe09fd03014d018126aa72

One hunk: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, in the Sized-obligation branch of the error reporting (around line 3010).
Removed the call `self.suggest_borrow_for_unsized_closure_return(obligation.cause.body_def_id, err, obligation.predicate);`.
Re-expresses fix.diff hunk `@@ -2746,6 +2746,11 @@` in fulfillment_errors.rs, which added that call. The helper in suggestions.rs is left in place (now unused), matching the parent commit where it did not exist. The "consider borrowing the value" suggestion is no longer emitted.
