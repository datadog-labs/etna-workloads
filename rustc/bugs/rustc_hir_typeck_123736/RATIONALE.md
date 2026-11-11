# Adapted injection for Don't delay a bug if we suggest adding a semicolon to the RHS of an assign operator

Fix: https://github.com/rust-lang/rust/commit/889ca7e2164a0032d668cb6b1e148507dc2bd9b2

# Rationale
File compiler/rustc_hir_typeck/src/op.rs, function reporting binop errors (where `check_for_missing_semi` is called).
In 1.99.1 the fix's condition became `maybe_missing_semi && self.is_lhs_of_assign_stmt(expr)`.
Reverted to the pre-fix condition: downgrade to delayed bug whenever the parent is `ExprKind::Assign(..)`, without checking
that `expr` is the LHS (fix hunk `@@ -382,11 +382,17 @@`, removed `lhs.hir_id == expr.hir_id` check / `Assign(lhs, _, _)`).
So a binop on the RHS of an assignment has its error delayed and no error is emitted (ICE-style delayed bug).
