# Adapted injection for Fail typeck for illegal break-with-value

Fix: https://github.com/rust-lang/rust/commit/0c8bdd0bf33c2313ad9d0be495ffde8f4532237a

# Rationale
File compiler/rustc_hir_typeck/src/expr.rs, fn check_expr_break: in the break-with-value branch, replaced the
`opt_coerce_to.unwrap_or_else(|| { span_delayed_bug; set_tainted_by_errors; Ty::new_error(..) })` with the pre-fix
`opt_coerce_to.unwrap_or_else(|| Ty::new_misc_error(tcx))`, so the illegal break no longer taints typeck results.
Re-expresses fix hunk `@@ -625,10 +625,15 @@` (which replaced `unwrap_or_else(|| Ty::new_misc_error(tcx))` with an early return of the error type; the 1.99.1 code had evolved into the tainting variant).
