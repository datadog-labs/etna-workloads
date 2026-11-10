# Adapted injection for Dont collect assoc ty item bounds from trait where clause for host effect predicates

Fix: https://github.com/rust-lang/rust/commit/549a5d8b2843cff903a872ffa682f34d74bb341a

# Rationale
File: compiler/rustc_hir_analysis/src/collect/item_bounds.rs, fn associated_type_bounds.
Fix hunk `@@ -53,37 +54,48 @@` moved the "collect `where Self::Assoc: Trait` from parent trait" block
(trait_explicit_predicates_and_bounds + remap_gat_vars_and_recurse_into_nested_projections) inside the
`All | SelfOnly | ...` match arm, so ConstIfConst/SelfConstIfConst filters get nothing.
I reverted: the block is now after the match and runs for every filter (including const-if-const).
