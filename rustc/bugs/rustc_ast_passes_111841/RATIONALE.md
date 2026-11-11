# Adapted injection for Run AST validation on match guards correctly

Fix: https://github.com/rust-lang/rust/commit/72d41f3bd36d3c18c31f719a7f8e2a0ca372c332

# Rationale
compiler/rustc_ast_passes/src/ast_validation.rs: added `AstValidator::visit_arm` override (1.99.1 no longer has the
`ExprKind::Match` arm-walking code in the validator, so it is re-expressed as visit_arm).
Re-expresses fix hunk `@@ -736,11 +736,10 @@ impl<'a> Visitor<'a> for AstValidator<'a>`: the buggy parent had
`if let Some(guard) = &arm.guard && let ExprKind::Let(_, guard_expr, _) = &guard.kind { visit_expr(guard_expr) }`,
i.e. only `let` guards were visited and other guards (e.g. a block containing `unsafe mod`) were never validated;
the fix changed it to `if let Some(guard) = &arm.guard { visit_expr(guard) }`.
(The as_operand.rs hunks of the fix are formatting/refactor only; not re-injected.)
