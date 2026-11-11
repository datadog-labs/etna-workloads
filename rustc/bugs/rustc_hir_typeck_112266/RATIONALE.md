# Adapted injection for Fix type-inference regression in #112225

Fix: https://github.com/rust-lang/rust/commit/75b557a2c416f997385a886b39e7ef7625073f5a

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, fn `FnCtxt::check_argument_types`.
Re-expresses the fix hunk `@@ -362,7 +362,16 @@`: replaced the `is_closure = if let ExprKind::Closure(closure) = arg.kind { !tcx.coroutine_is_async(..) } else { false }` (and its comment) with the pre-fix `let is_closure = matches!(arg.kind, ExprKind::Closure { .. });`. Async blocks are thus treated as closures again, changing arg check order and regressing inference (#112225).
