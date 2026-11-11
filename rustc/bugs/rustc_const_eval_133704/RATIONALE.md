# Adapted injection for fix ICE when promoted has layout size overflow

Fix: https://github.com/rust-lang/rust/commit/a17294dc0fe106f0a8f12f8bc61ab17eacf251ef

# Rationale
File: compiler/rustc_const_eval/src/const_eval/error.rs, fn `report`.
Re-expresses the fix hunk `@@ -152,7 +154,12 @@ where`:
`-let can_be_spurious = matches!(error, InterpErrorKind::ResourceExhaustion(_));`
`+let allowed_in_infallible = matches!(error, ResourceExhaustion(_) | InvalidProgram(_));`
The bug: InvalidProgram errors (e.g. layout size overflow in a promoted) are no longer marked
allowed-in-infallible, so the interpreter's promoted check in eval_context.rs hits span_bug (ICE).
Other fix hunks were already largely applied/renamed in 1.99.1; only this one is reverted.
