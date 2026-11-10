# Adapted injection for Emit an error for unstable attributes that reference already stable features

Fix: https://github.com/rust-lang/rust/commit/497100a13c72d290a167ae6eb5566fca653ba99f

In 1.99.1 the check moved to compiler/rustc_attr_parsing/src/attributes/stability.rs, fn parse_unstability.
Removed the block `if ACCEPTED_LANG_FEATURES.iter().any(|f| f.name == feature) { emit UnstableAttrForAlreadyStableFeature; return None; }`.
This re-expresses the fix hunks in rustc_passes/src/stability.rs (@@ -246,12 +247,27 @@ `if let Stability { level: Unstable { .. }, feature } = stab { if ACCEPTED_FEATURES... emit_err(UnstableAttrForAlreadyStableFeature`), covering both #[unstable] and #[rustc_const_unstable] (same parser). The error struct/ftl remain (now unused-path), matching parent behaviour of no error.
