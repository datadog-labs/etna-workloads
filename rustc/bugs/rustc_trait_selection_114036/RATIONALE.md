# Adapted injection for Fix upcasting with normalization in old solver, add a test

Fix: https://github.com/rust-lang/rust/commit/238beae5e588fb3dc4550d970085b5bf29f40776

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/mod.rs, fn `match_upcast_principal` (the confirmation.rs code the fix touched was refactored into this helper in 1.99.1).
The `normalize_with_depth_to(... unnormalized_upcast_principal, &mut nested)` call is replaced by `unnormalized_upcast_principal.skip_norm_wip()`. This re-expresses fix hunk `@@ -887,9 +887,19 @@ ... confirm_trait_upcasting_unsize_candidate`, which added the `let upcast_principal = normalize_with_depth_to(...)` on `unnormalized_upcast_principal`. Without it the supertrait ref `Bar<<T as Mirror>::Assoc>` is not normalized and fails to match `dyn Bar<T>` in the old solver.
The second fix hunk (vtable lookup uses unnormalized principal) is already the case in 1.99.1 and needs no change.
