# Adapted injection for Make suggestion to change `Fn` to `FnMut` work with methods well

Fix: https://github.com/rust-lang/rust/commit/e47ea38da854eea3aebd35b43e3a4dfc7d25c651

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mutability_errors.rs, fn `expected_fn_found_fn_mut_call`, closure `get_call_details`.
Removed the `hir::ExprKind::MethodCall(..)` arm, so only plain `Call` expressions are recognised. This re-expresses the fix hunk
`@@ -937,56 +937,81 @@` which generalised the old `if let ExprKind::Call(func, args)` handling to also cover
`hir::ExprKind::MethodCall(_, _, args, span)` (via `type_dependent_def_id`). Without it, method calls get no
"change this to accept `FnMut`" suggestion (the pre-fix behaviour).
