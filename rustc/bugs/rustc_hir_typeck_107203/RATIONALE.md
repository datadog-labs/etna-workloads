# Adapted injection for Fix #106496, suggest remove deref for type mismatch

Fix: https://github.com/rust-lang/rust/commit/2aa5555ad3911536e2d0d363633f1a4cb67b1c49

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn suggest_deref_or_ref (the code formerly in demand.rs).
Removed the block `if let hir::ExprKind::Unary(hir::UnOp::Deref, inner) = expr.kind && let Some(1) = self.deref_steps_for_suggestion(expected, checked_ty) ... return Some((.. "consider removing deref here" ..))`.
This re-expresses the fix hunk `@@ -1233,6 +1233,22 @@` in demand.rs, which added that block. Without it, `foo(*hello)` gets the "consider borrowing here" suggestion instead of removing the deref.
