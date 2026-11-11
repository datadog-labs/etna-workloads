# Adapted injection for fix: skip implied bounds if unconstrained lifetime exists

Fix: https://github.com/rust-lang/rust/commit/ecf2a9b75ec591db6e89f4bde391b87f35c2ea08

# Hunk: compiler/rustc_trait_selection/src/traits/outlives_bounds.rs, fn implied_outlives_bounds
Changed `assert!(!ty.has_non_region_infer())` to `assert!(!ty.has_infer())`.
Fix hunk `@@ -55,7 +55,16 @@` replaced `assert!(!ty.needs_infer());` with an early return skipping implied bounds
when the type has unconstrained inference (lifetime) variables. In 1.99.1 the equivalent tolerance is that
only non-region infer vars are asserted against; restoring the strict assert re-creates the ICE from #110161.
