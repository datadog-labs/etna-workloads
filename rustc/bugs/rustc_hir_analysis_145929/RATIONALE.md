# Adapted injection for fix APITIT being treated as a normal generic parameter in suggestions

Fix: https://github.com/rust-lang/rust/commit/2f0c1035ed7a1ad2348565c8d3fc4c5c3e758a24

# Rationale
File: compiler/rustc_hir_analysis/src/check/mod.rs, fn `bounds_from_generic_predicates`.
Removed `.filter(|p| !p.kind.is_synthetic())` on `generics.own_params`.
Re-expresses fix hunk `@@ -353,34 +355,50 @@ fn bounds_from_generic_predicates`, which added
`.filter(|p| matches!(p.kind, GenericParamDefKind::Type { synthetic: false, .. }))`
so APITIT (synthetic `impl Trait` params) are not treated as normal generics in suggestions.
Without it, the synthetic param is emitted as a normal generic in the suggested signature.
