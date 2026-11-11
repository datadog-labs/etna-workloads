# Adapted injection for RPITITs are considered object-safe, they're always on Self:Sized methods

Fix: https://github.com/rust-lang/rust/commit/7a6b52bf0d29b614df0e9528798462ad8ab53d7e

# Rationale
The fix skipped RPITITs (which are always `Self: Sized`-gated) when building the built-in `dyn Trait: Trait` projection bounds. In 1.99.1 this is expressed by a `generics_require_sized_self` filter, so I removed it in both places.

1. `compiler/rustc_trait_selection/src/traits/select/confirmation.rs`, `confirm_object_candidate`: removed `.filter(|item| !tcx.generics_require_sized_self(item.def_id))` on `assoc_types`. Re-expresses the hunk `@@ -535,6 +535,9 @@ ... confirmation.rs` (`.filter(|item| !item.is_impl_trait_in_trait())`).
2. `compiler/rustc_next_trait_solver/src/solve/assembly/structural_traits.rs`, `predicates_for_object_candidate`: removed the `if cx.generics_require_sized_self(..) { continue; }`. Re-expresses the hunk `@@ -354,6 +354,12 @@ predicates_for_object_candidate` (`if item.is_impl_trait_in_trait() { continue; }`).

The removal is broader than the original filter (it also covers `Self: Sized` GATs), but it is the 1.99.1 form of the same check.
