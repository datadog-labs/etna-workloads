# Adapted injection for compiler: use `is_rustic_abi` in ty_utils

Fix: https://github.com/rust-lang/rust/commit/8a689878ced1b3c0834ea32265c7d1cd43750db4

# Rationale
compiler/rustc_ty_utils/src/abi.rs, `fn_abi_adjust_for_abi`: replaced `abi.is_rustic_abi()` with
`abi == ExternAbi::Rust || abi == ExternAbi::RustCall`, so rust-cold (and other rustic ABIs) go through
`adjust_for_foreign_abi` instead of `adjust_for_rust_abi`.
Re-expresses fix hunk `@@ -687,7 +684,7 @@ fn fn_abi_adjust_for_abi`:
`-if abi == ExternAbi::Rust || abi == ExternAbi::RustCall || abi == ExternAbi::RustIntrinsic {` / `+if abi.is_rustic_abi() {`.
(RustIntrinsic no longer exists in 1.99.) The sanity-check hunk (@@ -436) is already equivalent in behavior, left unchanged.
