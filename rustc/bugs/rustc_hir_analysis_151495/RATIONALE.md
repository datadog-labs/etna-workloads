# Adapted injection for Fix ICE when using zero-length SIMD type in extern static

Fix: https://github.com/rust-lang/rust/commit/b97036628f23f3fda9251986f0268aff7eb0d593

# Rationale
File: compiler/rustc_hir_analysis/src/check/check.rs, fn `check_static_inhabited`.
Removed the match arm `Err(e @ LayoutError::InvalidSimd { .. }) => { ...emit error; return; }`.
Re-expresses fix hunk `@@ -192,6 +193,12 @@ fn check_static_inhabited` (added the InvalidSimd arm). Without it, the error falls to the generic `Err(e)` arm (span_delayed_bug), so no diagnostic is emitted for zero-length/oversized SIMD extern statics (ICE-like delayed bug). The `Spanned` import hunk doesn't exist in 1.99.1 (code uses span_err), so nothing to revert there.
