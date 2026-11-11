# Adapted injection for Register `ConstArgHasType` obligation when normalizing trait projection consts

Fix: https://github.com/rust-lang/rust/commit/a055c7cff03b60e5de5ef5a9b53066a4850f64c0

# Rationale
1.99.1 refactored the fix into helpers (`push_const_arg_has_type_obligation`, `push_const_arg_has_type_goal`). I removed the calls on the impl-candidate normalization paths.

1. `compiler/rustc_trait_selection/src/traits/project.rs`, `confirm_impl_candidate`. I removed the call to `push_const_arg_has_type_obligation`. This re-expresses the fix hunk `@@ -2049,7 +2049,19 @@ fn confirm_impl_candidate`, which added `nested.push(Obligation ... ClauseKind::ConstArgHasType(ct, expected_ty))`.
2. `compiler/rustc_next_trait_solver/src/solve/normalizes_to.rs`, `instantiate_normalizes_to_term`. I removed the call to `push_const_arg_has_type_goal`. This re-expresses the fix hunk `@@ -410,10 +410,22 @@` (the `ecx.add_goal(... ConstArgHasType(ct, expected_ty))` for type-const projections in the impl candidate).
