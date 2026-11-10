# Adapted injection for Filter out RPITITs when suggesting unconstrained assoc type on too many generics

Fix: https://github.com/rust-lang/rust/commit/88d7ea36e9eb0e157d465e75ace7b0a19f154b01

# Hunk
File: compiler/rustc_hir_analysis/src/diagnostics/wrong_number_of_generic_args.rs (moved from errors/), fn `get_unbound_associated_item`.
Removed `&& !item.is_impl_trait_in_trait()` from the filter. Re-expresses fix hunk
`@@ -495,6 +495,7 @@ impl WrongNumberOfGenericArgs` which added `.filter(|item| !item.is_impl_trait_in_trait())`.
Without it, RPITITs are offered as unconstrained assoc types in the "too many generics" suggestion.
