# Adapted injection for Do not require associated types with Self: Sized to uphold bounds when confirming object candidate

Fix: https://github.com/rust-lang/rust/commit/07fc6441327a02dd8aa8497b1e4e890f1801e8cf

# Rationale
Both hunks restore the pre-fix filter that skipped only RPITITs instead of all assoc types with `Self: Sized`.

1. compiler/rustc_trait_selection/src/traits/select/confirmation.rs, `confirm_object_candidate`: the filter
   `!tcx.generics_require_sized_self(item.def_id)` became `!item.is_impl_trait_in_trait()`.
   Re-expresses fix hunk `@@ -535,9 +535,9 @@ ... confirm_object_candidate` (the `.filter(|item| !tcx.generics_require_sized_self(item.def_id))` line).
   Assoc types with `where Self: Sized` must now uphold their bounds for `dyn Trait`.
2. compiler/rustc_next_trait_solver/src/solve/assembly/structural_traits.rs, `predicates_for_object_candidate`:
   `if cx.generics_require_sized_self(..)` became `if cx.is_impl_trait_in_trait(..)`.
   Re-expresses fix hunk `@@ -354,9 +354,9 @@ predicates_for_object_candidate` in solve/assembly/structural_traits.rs
   (the file has moved to rustc_next_trait_solver in 1.99.1).
