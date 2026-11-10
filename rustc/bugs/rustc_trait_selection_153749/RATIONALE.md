# Adapted injection for Account for ownership mismatch on argument that doesn't meet bound

Fix: https://github.com/rust-lang/rust/commit/a61412069d0fbddffa223faef5212e3c796d47ba

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn suggest_dereferencing/borrowing helper (the fn containing `mk_result` / `WhereClauseInExpr` match).

Removed the `else if let hir::ExprKind::Call(_, args) = expr.kind { ... point_at_relevant_args(...) ... return false }` branch inside the first `WhereClauseInExpr` arm. This re-expresses fix hunk `@@ -1643,85 +1643,215 @@` which added the `} else if let hir::ExprKind::Call(_, args) = expr.kind {` branch that labels plain-call arguments with "`T` doesn't satisfy the trait bound" and suggests "consider borrowing these argument". Without it, ordinary fn calls (`foo(hi, hi, hi)`) get no ownership-mismatch label/suggestion (pre-fix behaviour; only method calls were handled).
