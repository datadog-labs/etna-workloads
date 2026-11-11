# Adapted injection for interpret: do not ICE when a promoted fails with OOM

Fix: https://github.com/rust-lang/rust/commit/c6974344a5707c054ed808ea9c724dd93ec3c680

# Rationale
File compiler/rustc_const_eval/src/const_eval/error.rs, fn report (tail of error reporting).
In 1.99.1 the fix's `can_be_spurious` is renamed `allowed_in_infallible` (ReportedErrorInfo::allowed_in_infallible).
Fix hunk `@@ -152,13 +152,20 @@`: `let can_be_spurious = matches!(error, InterpErrorKind::ResourceExhaustion(_));` marked OOM as spurious.
Reinjected by removing `ResourceExhaustion(_)` from the `allowed_in_infallible` matches!, so OOM in a promoted is a hard const-eval error again and the interpreter ICEs for infallible promoteds.
The other two fix hunks (data field/constructors, eval_context check) already exist unchanged in 1.99.1 and were left alone.
