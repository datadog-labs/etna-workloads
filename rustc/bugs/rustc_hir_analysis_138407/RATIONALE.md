# Adapted injection for Delegation: reject C-variadics

Fix: https://github.com/rust-lang/rust/commit/ccdba16f42c951163d00c7e6cd7051be64d2f847

# Rationale
File compiler/rustc_hir_analysis/src/delegation.rs, fn check_constraints: removed the block
`if tcx.fn_sig(sig_id).skip_binder().skip_binder().c_variadic() { emit("delegation to C-variadic functions is not allowed"); }`
Re-expresses the fix hunk `@@ -409,6 +409,11 @@ fn check_constraints<'tcx>(` which added that check (here `c_variadic()` is a method in 1.99.1). Without it, delegation to C-variadic fns is accepted.
