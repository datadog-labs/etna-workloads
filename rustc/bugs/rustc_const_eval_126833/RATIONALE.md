# Adapted injection for don't ICE when encountering an extern type field during validation

Fix: https://github.com/rust-lang/rust/commit/763e3131cc05d9d9b036ce991cc948aefe2cb8ff

# Rationale
One hunk: compiler/rustc_const_eval/src/interpret/validity.rs, validation entry (`validate_operand_internal`'s `.inspect_err_info`).
It removes `InterpErrorKind::Unsupported(_)` from the list of error kinds allowed to escape validation, so
an `Unsupported` error (e.g. ExternTypeField from an extern-type tail field) hits `bug!("Unexpected error during validation")` and ICEs.
Re-expresses fix hunk `@@ -1028,7 +1028,9 @@ ... Err(err) if matches!(err.kind(), err_ub!(ValidationError{..}) | InterpError::InvalidProgram(_) | InterpError::Unsupported(UnsupportedOpInfo::ExternTypeField))`
(in 1.99.1 the fix's allowance was generalised to `Unsupported(_)`; removing it restores the pre-fix ICE).
