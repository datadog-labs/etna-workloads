# Adapted injection for Suggest return type for async function without return type

Fix: https://github.com/rust-lang/rust/commit/6b05b80690fe6548b49da46f85b9ec7b1ea95e7e

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn `suggest_missing_return_type`.
Removed the `else if let hir::TyKind::OpaqueDef(op_ty, ..) = hir_ty.kind && ... constraint.ty()` branch that detects an async fn with omitted return type and emits `AddReturnTypeSuggestion::Add` (or the `ExpectedReturnTypeLabel::Other` label). This re-expresses fix hunk `@@ -704,10 +704,38 @@` in suggestions.rs, which added the `if let hir::TyKind::OpaqueDef(...) ... // Check if async function's return type was omitted` block. Without it the "try adding a return type" help is lost for `async fn hello() { 0 }`.
The _impl.rs hunk (closure-in-async-fn lookup in get_fn_decl) was not reverted.
