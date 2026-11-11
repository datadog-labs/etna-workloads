# Adapted injection for improve error messages for `C-cmse-nonsecure-entry` functions

Fix: https://github.com/rust-lang/rust/commit/10aa255541964bceddaac8f49d7a11f1d736e24d

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/cmse.rs, `validate_cmse_abi`.
Re-expresses fix hunk `@@ -17,61 +17,104 @@ pub(crate) fn validate_cmse_abi` which added the
`abi::Abi::CCmseNonSecureEntry => { ... is_valid_cmse_inputs / is_valid_cmse_output ... CmseEntryGeneric / CmseOutputStackSpill }` arm.
Before the fix, only `C-cmse-nonsecure-call` was validated. In 1.99.1 the Entry arm
(which fetches the fn decl, validates inputs/outputs) is replaced by `ExternAbi::CmseNonSecureEntry => return`,
so entry functions get no register-fit/generic checks (the pre-fix behaviour).
