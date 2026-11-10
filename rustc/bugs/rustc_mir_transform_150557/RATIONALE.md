# Adapted injection for Don't evaluate const blocks in constant promotion

Fix: https://github.com/rust-lang/rust/commit/4039cef09ef4eb6b4731195338ce8b238f562a5d

# Rationale
File: compiler/rustc_mir_transform/src/promote_consts.rs, `Validator::validate_place` (index case) and `validate_rvalue` (int division/remainder, rhs and lhs).
Removed the `&& self.should_evaluate_for_promotion_checks(..)` guards (3 sites), so const blocks (inline consts) are evaluated during promotion again, causing the query cycle of #150464.
Re-expresses fix hunks:
- `@@ -329,6 +330,7 @@ ... && self.should_evaluate_for_promotion_checks(c.const_)` before try_eval_target_usize
- `@@ -484,7 +486,9 @@` / `@@ -502,9 +506,14 @@` guards on `try_eval_scalar_int` for rhs and lhs (in 1.99.1 these are `&& self.should_evaluate_for_promotion_checks(rhs_c/lhs_c.const_)`).
The helper fn (fix hunk @@ -683) and import are left in place unused.
