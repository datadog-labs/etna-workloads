# Adapted injection for Don't ICE in CTFE if raw/fn-ptr types differ

Fix: https://github.com/rust-lang/rust/commit/025ad403a976cbb80a3a472e333f4544baef9261

# Rationale
File: compiler/rustc_const_eval/src/check_consts/check.rs, `Checker::visit_rvalue` (Rvalue::BinaryOp arm, fn-ptr/raw-ptr comparison branch).
Re-expresses fix hunk `@@ -581,7 +581,6 @@ impl<'tcx> Visitor<'tcx> for Checker<'_, 'tcx>` which removed `assert_eq!(lhs_ty, rhs_ty);`.
Re-added that assert, so comparing fn pointers with different binders (`fn(&'static ())` vs `for<'a> fn(&'a ())`) ICEs in const checking.
