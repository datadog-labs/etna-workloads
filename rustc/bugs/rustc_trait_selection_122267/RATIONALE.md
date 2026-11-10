# Adapted injection for Instantiate closure-like bounds with placeholders to deal with binders correctly

Fix: https://github.com/rust-lang/rust/commit/5f59b7f7634ac4b05923b47de00f2a13b213af1f

All changes in compiler/rustc_trait_selection/src/traits/select/confirmation.rs.

1. `confirm_fn_pointer_candidate` — re-expresses fix hunk `@@ -678,17 +678,10 @@ ... confirm_fn_pointer_candidate`
   (removed `let Some(self_ty) = ...no_bound_vars() else { // FIXME: Ideally we'd support for<'a> fn(&'a ()): Fn(&'a ()) ... return Err(Unimplemented) }`,
   added `enter_forall_and_leak_universe`). The bail-out is restored; on 1.99.1 the FnDef's own self type never has escaping bound vars, so it is
   keyed on `obligation.predicate.no_bound_vars()` (the FIXME's `for<'a> ...: Fn(&'a ())` case). This is the hunk that makes the oracle fail.
2. `confirm_future_candidate`, `confirm_iterator_candidate`, `confirm_async_iterator_candidate`: restored `obligation.self_ty().skip_binder()` and
   `obligation.predicate.no_bound_vars().expect("... no bound vars").self_ty()` (fix hunks `@@ -748,10 +746,8 @@`, `-786`, `-815`, `-844`).
3. `confirm_closure_candidate`: restored `no_bound_vars().expect("unboxed closure type should not capture bound vars ...")` for the closure self type
   (fix hunk `@@ -874,14 +875,15 @@`, and the mod.rs `closure_trait_ref_unnormalized` hunk).
Hunks 2 and 3 do not trigger on the oracle tests; they are harmless restorations.
