# Adapted injection for make enabling the neon target feature a FCW

Fix: https://github.com/rust-lang/rust/commit/3c020e59a24a7739968fbd891a09e316a86c7b40

# Rationale
File: compiler/rustc_codegen_ssa/src/target_features.rs, fn from_target_feature_attr.
Re-expresses the hunk `@@ -92,11 +94,22 @@` of fix.diff: the fix added an `if arch == aarch64 && name == "neon"` branch emitting the AARCH64_SOFTFLOAT_NEON FCW lint instead of the hard error `ForbiddenTargetFeatureAttr` (now `InternalOnlyTargetFeatureAttr`). I removed that branch so the ABI-incompatible neon feature is always a hard error (pre-fix behaviour). The lint/diagnostic definitions are left in place (now unused).
