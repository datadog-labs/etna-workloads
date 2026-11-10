# Adapted injection for  unconstrained region vars: do not ICE ICE baby

Fix: https://github.com/rust-lang/rust/commit/98fa0c93ee031277e64eaee11fe9dbfe2147f532

# Rationale
File: compiler/rustc_trait_selection/src/traits/outlives_bounds.rs, fn `implied_outlives_bounds`.
Re-adds, after `assert!(!ty.has_non_region_infer());`, the block the fix removed
(hunk `@@ -57,16 +57,12 @@`, removed lines `if ty.has_infer() { ...delay_span_bug("skipped implied_outlives_bounds due to unconstrained lifetimes"); return vec![]; }`).
Uses the modern `dcx().delayed_bug`. Unconstrained region vars now yield no implied bounds and a delayed bug (ICE in check-pass code).
