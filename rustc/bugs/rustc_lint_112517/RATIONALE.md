# Adapted injection for `suspicious_double_ref_op`: don't lint on `.borrow()`

Fix: https://github.com/rust-lang/rust/commit/1e36f7e9ae2a99139cf383193141e1429a20faf1

# Rationale
Fix hunk 2 (`@@ -129,6 +129,9 @@ ... } else { + if op == "borrow" { return; }`) made the double-ref branch skip `.borrow()`.
In 1.99.1 this is `check_expr` in compiler/rustc_lint/src/noop_method_call.rs: the `sym::noop_method_borrow => return,` arm is replaced by emitting SUSPICIOUS_DOUBLE_REF_OP with a new `SuspiciousDoubleRefBorrowDiag` (added in compiler/rustc_lint/src/diagnostics.rs, mirroring the Clone/Deref diags) so `.borrow()` lints again.
Fix hunk 1 (refactor of the trait matching) is behaviour-neutral; not re-expressed.
