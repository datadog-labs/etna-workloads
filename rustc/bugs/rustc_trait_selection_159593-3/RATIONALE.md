# Adapted injection for merge ambiguity errors that blame the same inference variable

Fix: https://github.com/rust-lang/rust/commit/7617fb98827585bfe592973b8c9314f99d902dd4

# Rationale

File: compiler/rustc_trait_selection/src/error_reporting/traits/mod.rs, `report_fulfillment_errors`.

Single change: the `group` of ambiguity errors sharing an inference variable (`infer_vars[index]` match) is now always `vec![]`; `infer_vars` is renamed `_infer_vars` (unused).
Re-expresses fix hunk `@@ -250,12 +252,94 @@ ... report_fulfillment_errors`, the block "Ambiguity errors blaming the same inference variable describe a single problem" that grouped errors by sub-unification root and passed `related` to `report_fulfillment_error`. With no group, `related` is empty and `merged` is never set, so every ambiguity error is reported separately and the later ones are dropped after `set_tainted_by_errors`, which is the pre-fix behaviour.
