# Adapted injection for Add implied target features to target_feature attribute

Fix: https://github.com/rust-lang/rust/commit/74653b61a67ae7db9f77ea1e09e65e40686c9058

# Rationale
File: compiler/rustc_codegen_ssa/src/target_features.rs, `provide` -> `implied_target_features` query provider.
Re-expresses fix hunk `@@ -162,6 +162,28 @@ pub(crate) fn provide` (the new `implied_target_features` query that traverses the implied-feature map transitively) and the `from_target_feature` hunk using `tcx.implied_target_features(*feature)`.
In 1.99.1 the query exists; I make it return only `[feature]` (early return), so no implied features (e.g. avx2 -> avx, fma -> avx) are added to `#[target_feature]`, as before the fix (the parent only had the wasm implicit table, which cannot be expressed here since no `sym::simd128`).
