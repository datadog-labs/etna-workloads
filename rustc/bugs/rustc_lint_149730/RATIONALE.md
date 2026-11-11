# Adapted injection for lint: treat unsafe binders in improper_ctypes instead of ICE

Fix: https://github.com/rust-lang/rust/commit/0f4ec281558a40645b125fda43f36d7006180e54

# Rationale
File: compiler/rustc_lint/src/types/improper_ctypes.rs, fn check_type_for_ffi (the `ty::UnsafeBinder(_)` arm).
Re-expresses the fix hunk `@@ -669,7 +669,9 @@ impl<'a, 'tcx> ImproperCTypesVisitor` which replaced
`ty::UnsafeBinder(_) => todo!("FIXME(unsafe_binder)")` with an `FfiUnsafe { reason: lint_improper_ctypes_unsafe_binder }`.
Here the FfiUnsafe arm is restored back to `todo!("FIXME(unsafe_binder)")`, so an unsafe binder in an extern signature ICEs.
The messages.ftl hunk (new message) is not reverted: in 1.99.1 the message is an inline `msg!`, so it disappears with the arm.
