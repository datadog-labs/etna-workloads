# Adapted injection for Properly mark loop as diverging if it has no breaks

Fix: https://github.com/rust-lang/rust/commit/74754b878621b42097de33f9579d7630fa704627

# Hunk: compiler/rustc_hir_typeck/src/expr.rs, FnCtxt::check_expr_loop
Removed the `else { self.diverges.set(self.diverges.get() | Diverges::always(expr.span)); }` after `if ctxt.may_break { ... Diverges::Maybe }`.
Re-expresses fix hunk `@@ -1306,6 +1306,8 @@` which added that else branch (loop with no breaks marked diverging).
The _impl.rs hunk (warn_if_unreachable refactor) was not reverted; the expr.rs part alone makes the oracle fail.
