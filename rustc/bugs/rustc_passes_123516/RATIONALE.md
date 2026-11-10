# Adapted injection for Do not ICE on field access check on expr with `ty::Error`

Fix: https://github.com/rust-lang/rust/commit/97ea48ce326fc60973700297cce07980ca76d1f2

# Rationale
Both hunks are in compiler/rustc_passes/src/dead.rs.

1. `MarkSymbolVisitor::handle_field_access`: removed the `ty::Error(_) => {}` arm. This re-expresses the fix hunk
   `@@ -153,7 +153,8 @@ impl<'tcx> MarkSymbolVisitor<'tcx>` (`+            ty::Error(_) => {}`). Without it, a field access on an error-typed expression hits `span_bug!`.
   (The `{kind:?}` message part is kept; it is harmless.)
2. `MarkSymbolVisitor::visit_nested_body`: removed the early `ControlFlow::Break` for bodies where `typeck_results.tainted_by_errors` is set.
   In 1.99.1 this guard hides the bug (reversing hunk 1 alone gives no failure). Removing it restores the situation of the parent commit,
   where error-tainted bodies were visited and reached the `ty::Error` field-access case. This is a supporting change that makes hunk 1 reachable.
