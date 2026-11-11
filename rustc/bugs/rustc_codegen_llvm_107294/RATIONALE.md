# Adapted injection for Only disable folded features when it makes sense.

Fix: https://github.com/rust-lang/rust/commit/aab0757c666504f36c5a382304ec5390fc4f7454

# Rationale
The fix made folded (tied) features only fold on disable when strength is `Both` (`feature_fold_strength`); the parent folded on both enable and disable (e.g. `-sve` also gave `-neon`).

1. compiler/rustc_codegen_llvm/src/llvm_util.rs, `llvm_features_by_flags` closure `extend_backend_features`.
   Re-expresses hunk `@@ -471,11 +491,17 @@ global_llvm_features`: the match arm `('+', TargetFeatureFoldStrength::EnableOnly)` that only folds EnableOnly deps when enabling. Now `(_, EnableOnly(f))` folds on disable as well (the pre-fix behaviour).
2. compiler/rustc_codegen_ssa/src/target_features.rs, `parse_rust_feature_list` (the `-feature` branch).
   In 1.99.1 the sve->neon tie is a Rust-level implied feature (`("sve", Stable, &["neon","fp16"])`), not an LLVM dependency. This hunk makes disabling also add the forward implied features, i.e. the old unconditional fold on disable, which the fix's `EnableOnly` strength removed. This is what makes DISABLE_SVE fail (`-sve,-neon,-fp16...`).
