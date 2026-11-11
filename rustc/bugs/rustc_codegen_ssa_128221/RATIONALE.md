# Adapted injection for Add test to ensure implied target features work with asm, and fix failing tests

Fix: https://github.com/rust-lang/rust/commit/22c59529441da1cca8eb2cc50d4162e3adf95355

# Hunk: compiler/rustc_codegen_ssa/src/target_features.rs, from_target_feature_attr
The loop that adds a `#[target_feature]` feature plus its implied features now keeps only the feature itself
(`.iter().filter(|&&n| n == feature)`), so implied features are dropped from codegen attrs.
Re-expresses fix hunk `@@ -99,12 +99,14 @@ pub fn from_target_feature(` ("Add both explicit and implied target features"),
which made sure implied features of explicit features are included in the function's target features.
The old code is rewritten on 1.99.1, so the nearest equivalent was to drop the implied features.
