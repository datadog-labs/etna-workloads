# Adapted injection for Do not assert >1 RPITITs on collect_return_position_impl_trait_in_trait_tys

Fix: https://github.com/rust-lang/rust/commit/07a230b5a5819d9a0bcfdf77bec8e9d4d9ba1ea9

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn `collect_return_position_impl_trait_in_trait_tys`.

Fix hunk `@@ -669,11 +669,13 @@ pub(super) fn collect_return_position_impl_trait_in_trait_tys` wrapped
`debug_assert_ne!(collector.types.len(), 0, "expect >1 RPITITs ...")` in
`if !unnormalized_trait_sig.output().references_error()`.
In 1.99.1 the check had become `if !...references_error() && collector.types.is_empty() { delayed_bug }`, placed after
`trait_sig.error_reported()?` (so it was never reached for error sigs / delayed bug is suppressed by emitted errors).
I restored the pre-fix form: an unconditional `debug_assert_ne!(collector.types.len(), 0, ...)` placed immediately after
the `.fold_with(&mut collector)` (before normalization and the error early return), dropping the references_error guard.
