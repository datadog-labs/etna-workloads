# Adapted injection for Don't allow poly_select in new solver

Fix: https://github.com/rust-lang/rust/commit/16b6ffe0dbced4eeb1828b3a5674786dedc56cfc

# Rationale
Reverts the fix so the new solver goes through `poly_select` again with binder-carrying obligations.

1. `compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs` (secondary-span code, `~L1773`): replaced `enter_forall_and_leak_universe` + `select(...)` with `SelectionContext::new(self).poly_select(&obligation.with(tcx, predicate.kind().rebind(trait_ref)))`. Re-expresses hunk `@@ -1503,11 +1503,11 @@` (`let Ok(Some(ImplSource::UserDefined(impl_data))) = SelectionContext::new(self).poly_select(...)`).
2. `traits/select/mod.rs`: `poly_select` again dispatches `if next_trait_solver() { return select_in_new_trait_solver(obligation) }` instead of `assert!(!next_trait_solver())`; `select` no longer dispatches. Re-expresses hunks `@@ -265,9 +265,7 @@` and `@@ -299,6 +297,10 @@`.
3. `solve/select.rs`: `select_in_new_trait_solver` takes `&PolyTraitObligation` again (hunks `@@ -5,7 +5,7 @@`, `@@ -17,7 +17,7 @@`). Since the new solver has no binder support, the poly predicate is passed with `.skip_binder()` into `Goal::new`, leaving the bound regions escaping (without this, the release build still passed the test since the Binder was tolerated; the upstream failure was an ICE/escaping-bound-var issue).
