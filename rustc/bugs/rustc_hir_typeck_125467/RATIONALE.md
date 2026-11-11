# Adapted injection for Only suppress binop error in favor of semicolon suggestion if we're in an assignment statement

Fix: https://github.com/rust-lang/rust/commit/a02aba7c542bf65f53c3a631f56110d8d95afc1c

# Rationale
File compiler/rustc_hir_typeck/src/op.rs, fn `is_lhs_of_assign_stmt` (used by the binop error path to decide `err.downgrade_to_delayed_bug()`).
Removed the check that the parent Assign expr is itself a statement (`hir::Node::Stmt` with `StmtKind::Expr|Semi`), leaving only `lhs.hir_id == expr.hir_id`.
Re-expresses fix hunk `@@ -381,10 +381,13 @@` which added
`&& let hir::Node::Stmt(stmt) = self.tcx.parent_hir_node(parent.hir_id)` and `&& let hir::StmtKind::Expr(_) | hir::StmtKind::Semi(_) = stmt.kind`.
