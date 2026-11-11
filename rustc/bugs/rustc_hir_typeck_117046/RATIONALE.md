# Adapted injection for return unfixed len if pat has reported error

Fix: https://github.com/rust-lang/rust/commit/6de40abc890ef1f9d89f36f4309695de19b60d5e

# Rationale
File: compiler/rustc_hir_typeck/src/pat.rs, fn `check_array_pat_len`.

Re-expresses the fix hunk `@@ -2164,7 +2165,19 @@ ... check_array_pat_len`, whose key lines are:
`Err(ErrorHandled::Reported(..)) => { let guar = self.error_scrutinee_unfixed_length(span); return (Some(Ty::new_error(self.tcx, guar)), arr_ty); }`.
In 1.99.1 the length is obtained with `try_structurally_resolve_const(...)`, so an errored length shows up as `ConstKind::Error`. I added an early return for that case which emits E0730 (`error_scrutinee_unfixed_length`) and returns an error type.
The oracle test's stderr in 1.99.1 expects only E0425, so this extra E0730 makes issue-116186.rs fail. The fix's own stderr did expect E0730, but the test was later re-blessed, so on 1.99.1 the extra E0730 is the regression.
The `use ErrorHandled` import hunk is not needed.
