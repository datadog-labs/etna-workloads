# Adapted injection for Don't ICE in resolve_bound_vars when associated return-type bounds are in bad positions

Fix: https://github.com/rust-lang/rust/commit/b7191d8388abfb7c66b5fea9120cdf07c640edfa

# Rationale
File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, fn `poly_trait_ref_binder_info`-area scope walk (`Scope::TraitRefBoundary` arm).
Re-expresses hunk `@@ -338,7 +338,17 @@`: the fix replaced `assert!(supertrait_bound_vars.is_empty());` with a delayed bug when non-empty. I restored the hard assert, so an erroneous RTN bound in an impl header (#113423) ICEs again.
(The `DUMMY_SP` import hunk does not exist in 1.99.1, since the fix uses `dcx().delayed_bug` there.)
