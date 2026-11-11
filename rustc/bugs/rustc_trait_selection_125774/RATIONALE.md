# Adapted injection for Avoid unwrap diag.code directly

Fix: https://github.com/rust-lang/rust/commit/ed5205fe66ccd49116e99e4244483caaa8cf933e

In compiler/rustc_trait_selection/src/error_reporting/infer/note_and_explain.rs (moved from rustc_infer), two sites (in the type-param-constraint help in `note_and_explain_type_err`, and in `suggest_constraining_opaque_associated_type`/assoc-type help ~line 805) changed back from
`diag.code.is_some_and(|code| tcx.sess.teach(code))` to `tcx.sess.teach(diag.code.unwrap())`.
Re-expresses both fix hunks (`@@ -182,7 +182,7 @@` and `@@ -663,7 +663,7 @@`). A diagnostic without an error code (E.g. the const-param type mismatch) now panics on unwrap.
