# Adapted injection for fix macro attribute feature-gate span

Fix: https://github.com/rust-lang/rust/commit/9afd8e2899c131f6d0013588ddec0460afdc6896

# Hunk: compiler/rustc_expand/src/mbe/macro_rules.rs, expand_macro_attr
Removed the `if !is_local && !cx.ecfg.features.macro_attr() { feature_err(...).emit(); }` check
(1.99.1 form of the fix's hunk `@@ -468,6 +468,16 @@ fn expand_macro_attr`, which added
`if !is_local && !cx.ecfg.features.macro_attr() { return Err(feature_err(..., sp, "`macro_rules!` attributes are unstable").emit()); }`).
Without it, using a cross-crate `macro_rules!` attribute macro in a crate lacking the feature gate emits no error.
