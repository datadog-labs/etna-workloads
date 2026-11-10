# Adapted injection for TransmuteFrom: Gracefully handle unnormalized types and normalization errors

Fix: https://github.com/rust-lang/rust/commit/5b1a2b8712887fff7e0295d4e87aac24ea73797d

# Rationale
Only hunk re-expressed: compiler/rustc_transmute/src/layout/tree.rs, `impl From<&LayoutError> for Err`.
Fix hunk `@@ -195,10 +195,11 @@ pub(crate) mod rustc`: added `| LayoutError::NormalizationFailure(..)` to the UnknownLayout arm and removed `err => unimplemented!("{:?}", err)`.
Reintroduced: removed NormalizationFailure from the arm and restored the `err => unimplemented!` fallback (needed for exhaustiveness), so normalization failures ICE.
The fulfillment_errors.rs `Default` guard still exists in 1.99.1 and was left untouched.
