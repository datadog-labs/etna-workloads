# Adapted injection for Register `ConstArgHasType` obligation when normalizing inherent projection consts

Fix: https://github.com/rust-lang/rust/commit/7c5236891b6e8f7997795259c3e2a2475a2349a6

In 1.99.1 the fix's logic lives in helpers (`push_const_arg_has_type_goal`/`_obligation`) rather than inline.
Removed the calls so inherent const normalization no longer registers `ConstArgHasType`.

1. compiler/rustc_trait_selection/src/traits/project.rs, `normalize_inherent_projection`: removed the
   `push_const_arg_has_type_obligation(...)` call. Re-expresses hunk `@@ -554,6 +554,17 @@ normalize_inherent_projection`
   (`if let Some(ct) = term.as_const() { ... ConstArgHasType(ct, expected_ty) ...}`).
2. compiler/rustc_next_trait_solver/src/solve/project_goals/inherent.rs (was normalizes_to/inherent.rs): removed
   `self.push_const_arg_has_type_goal(...)` before `self.eq`. Re-expresses hunk `@@ -74,6 +75,16 @@` adding
   `self.add_goal(GoalSource::Misc, goal.with(cx, ty::ClauseKind::ConstArgHasType(ct, expected_ty)))`.
