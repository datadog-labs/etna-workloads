# Adapted injection for Check type of const param correctly in MIR typeck

Fix: https://github.com/rust-lang/rust/commit/0160c60c7883910fbd9eb59dc2b7bad2b5a3e01a

# Rationale
One hunk: `compiler/rustc_borrowck/src/type_check/mod.rs`, `visit_const_operand` (TypeChecker visitor).
Removed the `else if let Const::Ty(_, ct) = constant.const_ && let ty::ConstKind::Param(p) = ct.kind()` branch that calls `self.ascribe_user_type(... UserTypeKind::TypeOf(const_param.def_id, UserArgs{args: defining_ty.args(), ..}))`.
This re-expresses fix hunk `@@ -1773,6 +1773,22 @@ impl<'a, 'tcx> Visitor<'tcx> for TypeChecker` (added the branch). Without it, const param uses are not typed with the param's declared type in MIR typeck.
The `DefiningTy::args` helper (universal_regions.rs hunk) is still used elsewhere in 1.99.1, so it was left in place.
