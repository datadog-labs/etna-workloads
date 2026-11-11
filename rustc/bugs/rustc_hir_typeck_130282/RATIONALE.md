# Adapted injection for Do not report an excessive number of overflow errors for an ever-growing deref impl

Fix: https://github.com/rust-lang/rust/commit/d8a646fe77253232152f476386bb90fe562bd6f6

# Hunks
1. compiler/rustc_hir_typeck/src/method/probe.rs (probe_op): restored `if steps.reached_recursion_limit {` dropping `&& !is_suggestion.0`. Re-expresses fix hunk `@@ -375,7 +375,7 @@` (`-if steps.reached_recursion_limit {` / `+... && !is_suggestion.0`).
2. compiler/rustc_hir_typeck/src/method/suggest.rs (report_no_match_method_error, ~line 535): removed `.silence_errors()` from `self.autoderef(span, rcvr_ty)`. Re-expresses fix hunk `@@ -672,7 +672,7 @@` (`+let mut autoderef = self.autoderef(span, rcvr_ty).silence_errors();`).
The expr.rs hunk is already present in 1.99.1 (get_field_candidates_considering_privacy_for_diag); not reverted.
