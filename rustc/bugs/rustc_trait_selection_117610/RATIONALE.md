# Adapted injection for Don't instantiate the binder twice when assembling object candidate

Fix: https://github.com/rust-lang/rust/commit/171d5587ca1677ced9d1e70992a02091794cfb55

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs, fn assemble_candidates_from_object_ty.

Re-expresses both hunks of fix.diff (`@@ -628,18 +628,12 @@` and `@@ -671,18 +665,14 @@`): the fix instantiated the binder with placeholders
up front (`instantiate_binder_with_placeholders(poly_trait_predicate)`, self_ty from the placeholder predicate) and dropped the
`has_non_region_late_bound` early return / `erase_late_bound_regions`. I restored the old behaviour: bail out if the self-ty binder has non-region
bound vars, compute self_ty by erasing late-bound regions of `obligation.self_ty()` (1.99 API: `instantiate_bound_regions_with_erased`),
and only afterwards instantiate the binder with placeholders (via `enter_forall`, replacing the removed `instantiate_binder_with_placeholders`),
i.e. the binder is instantiated twice.
