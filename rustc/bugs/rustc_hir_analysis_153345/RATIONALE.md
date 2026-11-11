# Adapted injection for MGCA: fix type error handling for array and tuple lowering logic

Fix: https://github.com/rust-lang/rust/commit/ee1d0cfbe6b17fe77e1da569be33ac0ee7916be7

In compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, I removed the `ty::Error(e) => return Const::new_error(tcx, *e)` arm in two functions: the array-const lowering (`lower_const_arg_array`) and the tuple-const lowering (`lower_const_arg_tuple`).
This re-expresses both fix hunks (@@ -2416 and @@ -2539). They added `ty::Error(e) => return Const::new_error(...)` before the `_ =>` fallback.
Without that arm, an erroneous expected type falls into the fallback and emits a spurious "expected `{ty}`, found const array/tuple" error.
