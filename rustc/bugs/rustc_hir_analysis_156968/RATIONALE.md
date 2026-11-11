# Adapted injection for Suggest `generic_const_args` + `type const` in const operation diagnostics

Fix: https://github.com/rust-lang/rust/commit/920f3f1de86496764ee01940c49d3217a5fcac60

# Rationale
Only hunk applicable on 1.99.1 (the rustc_resolve hunks target files/structs that no longer exist there):
compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, `ForbidParamUsesFolder` error emission.
Re-expresses fix hunk `@@ -431,13 +431,16 @@ impl<'tcx> ForbidParamUsesFolder<'tcx>`: restores the old condition
`ConstArgument && min_generic_const_args()` with only the "add generic_const_args to allow generic expressions as the RHS of const items" / "consider factoring..." help,
removing the new branches suggesting `generic_const_exprs` + `generic_const_args`/`type const` for non-mgca users.
