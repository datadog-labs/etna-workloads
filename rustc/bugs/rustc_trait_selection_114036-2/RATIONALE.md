# Adapted injection for Rework upcasting

Fix: https://github.com/rust-lang/rust/commit/1bb6ae5874730933188fe4be56b3a2f3d5a66962

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/confirmation.rs, `confirm_trait_upcasting_unsize_candidate`.
Re-expresses the hunk `@@ -879,68 +879,89 @@` of fix.diff in confirmation.rs. The fix replaced the old algorithm
(rebuild a `dyn` type from `upcast_trait_ref` + `data_a.projection_bounds()` + `data_b.auto_traits()` with region `r_b`, then `.sup(target, source_trait)`)
with a per-bound check of b_data (principal / projection / auto trait). I restored the old algorithm in place of the call to `match_upcast_principal`
(which is the 1.99.1 home of the new per-bound loop). Result: upcasting to a dyn type with fewer projections (`dyn A<Assoc=i32>` -> `dyn B`) fails again.
The outlives obligation `a_region: b_region` is kept, as in the old code.
