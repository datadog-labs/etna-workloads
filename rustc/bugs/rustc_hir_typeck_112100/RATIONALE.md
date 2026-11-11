# Adapted injection for Don't typecheck suggested method call

Fix: https://github.com/rust-lang/rust/commit/e11ffb62dfda4850b971310b6f721141ba29f267

# Re-injection rationale
All changes are in compiler/rustc_hir_typeck/src/callee.rs.

1. `check_expr_call` (None arm): fix hunk `@@ -420,20 +420,14 @@` removed
   `if let Some(ty) = self.suggest_call_as_method(...) { diag.emit(); return ty; }`.
   Restored: the result of `suggest_call_as_method` is captured (`recovered_ty`) and, if `Some`, returned early as the call's type.
   (1.99.1 uses `try_steal_modify_and_emit_err` so the capture happens in the closure.)
2. `suggest_call_as_method`: fix hunks `@@ -496,9 +490,11 @@` / `@@ -513,7 +509,7 @@` / `@@ -525,7 +521,7 @@` changed the return type `Option<Ty<'tcx>>` -> `()`; restored `-> Option<Ty>`, `?` and `return None`.
3. Same function, fix hunk `@@ -567,22 +563,8 @@` removed "Let's check the method fully now" `check_method_argument_types(...)` and `return Some(return_ty)`. Restored via `check_argument_types` (the modern replacement of that helper) with the picked method's signature, and `Some(output)`.
