# Adapted injection for Adds recursion limit into FindParamInClause

Fix: https://github.com/rust-lang/rust/commit/8b83d4b4a6fe563fdf4b89c7b4dfe2c1fb0048ce

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/assembly/mod.rs

1. `FindParamInClause` struct + construction in `characterize_param_env_assumption`: removed the `recursion_depth` field and `recursion_depth: 0` initializer.
   Re-expresses fix hunks `@@ -1233,6 +1233,7 @@` (`recursion_depth: 0,`) and `@@ -1245,6 +1246,7 @@` (`recursion_depth: usize,`).
2. `FindParamInClause::visit_ty`: removed the depth increment / `recursion_limit()` check (which returned a Maybe(Overflow) certainty) / decrement, going back to plain `ty.super_visit_with(self)`.
   Re-expresses fix hunk `@@ -1274,7 +1276,13 @@` (`self.recursion_depth += 1; if self.recursion_depth > self.ecx.cx().recursion_limit() {...}`).
3. `characterize_param_env_assumption`: removed the early `if assumption.has_bound_vars() { return NonGlobal }`. In 1.99.1 this early return (added after the fix) masks the bug: the test's assumption has bound vars so the visitor is never reached (verified with debug prints). Removing it lets the unbounded recursion happen again (supporting change, not in fix.diff).
