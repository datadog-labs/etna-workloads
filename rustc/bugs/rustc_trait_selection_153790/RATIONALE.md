# Adapted injection for add generic & unresolved inference variables handling in `select_transmute_obligation_for_reporting`

Fix: https://github.com/rust-lang/rust/commit/fd45124860b739675e0df36a6531dbc98536f5a8

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs

1. `select_transmute_obligation_for_reporting`: removed the early return
   `if obligation.predicate.has_non_region_param() || obligation.has_non_region_infer() { return (obligation.clone(), trait_predicate); }`.
   Reverses the fix hunk `@@ -2832,6 +2832,10 @@ impl<'a, 'tcx> TypeErrCtxt<'a, 'tcx>` (the added guard).

2. `get_safe_transmute_error_and_reason`: removed the equivalent guard
   (`has_non_region_param() || has_non_region_infer()` -> `Default`). This does NOT trace to a fix hunk:
   in 1.99.1 this pre-existing guard masks hunk 1 (reversing hunk 1 alone gives no test failure), so it
   had to be removed too for the generic/infer case to reach `Assume::from_const`, which returns None for
   the inferred `_` assume and yields the delayed bug "Unable to construct rustc_transmute::Assume".
   Caveat: this is an extension needed to re-expose the bug on 1.99.1.
