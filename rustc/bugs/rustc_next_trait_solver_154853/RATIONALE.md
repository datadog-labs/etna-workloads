# Adapted injection for Register `ConstArgHasType` when normalizing free const aliases

Fix: https://github.com/rust-lang/rust/commit/1240be2939d29d3805b948cd7d203f34d904eed6

# Rationale
The fix registers `ConstArgHasType` when normalizing free const aliases. In 1.99.1 the code was moved/refactored, so two hunks were re-expressed by removal:

1. `compiler/rustc_next_trait_solver/src/solve/project_goals/free_alias.rs`, `normalize_free_alias`: removed
   `self.push_const_arg_has_type_goal(goal.param_env, goal.predicate.projection_term, actual)?;` before the `eq`.
   Re-expresses fix hunk `@@ -49,7 +49,7 @@` in free_alias.rs (`instantiate_normalizes_to_term_with_type_check` -> `instantiate_normalizes_to_term`, i.e. no type check for free aliases).
2. `compiler/rustc_trait_selection/src/traits/normalize.rs`, free alias normalization in `AssocTypeNormalizer`: removed the block pushing `ClauseKind::ConstArgHasType(ct, expected_ty)` obligation.
   Re-expresses fix hunk `@@ -356,6 +356,19 @@` ("When normalizing a free const alias, register a `ConstArgHasType` obligation").
