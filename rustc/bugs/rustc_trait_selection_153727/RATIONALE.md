# Adapted injection for When single impl can satisfy inference error, suggest type

Fix: https://github.com/rust-lang/rust/commit/49bb371ca74904400330e065dd847b6b9390b2a0

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/ambiguity.rs, fn maybe_report_ambiguity (E0283 branch).
Re-expresses the fix hunk `@@ -246,12 +246,37 @@`: removed the `candidates` computation over `all_impls(trait_pred.def_id())`
and the call to `emit_inference_failure_err_with_type_hint(..., match &candidates[..] { [candidate] => Some(*candidate), _ => None })`;
restored the original `emit_inference_failure_err(...)` call with no type hint, so a single satisfying impl is no longer suggested.
