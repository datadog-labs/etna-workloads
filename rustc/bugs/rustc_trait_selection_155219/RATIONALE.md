# Adapted injection for Do not suggest borrowing enclosing calls for nested where-clause obligations

Fix: https://github.com/rust-lang/rust/commit/9064d17405e21924fd87cd187ce64a7fbf17c63f

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn suggest_add_reference_to_arg (the closure handling WhereClauseInExpr).
Removed the block (3rd hunk of fix.diff in suggestions.rs, `@@ -1740,6 +1773,15 @@`):
    let old_self_ty = old_pred.skip_binder().self_ty();
    if !old_self_ty.has_escaping_bound_vars() && !self.where_clause_expr_matches_failed_self_ty(...) { return false; }
Without it, a nested where-clause obligation (`&String: Borrow<str>`) again leads to suggesting borrowing the whole enclosing call expression `foo(...)`.
The helper where_clause_expr_matches_failed_self_ty is left in place (still used in fulfillment_errors.rs).
