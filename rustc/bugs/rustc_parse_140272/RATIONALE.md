# Adapted injection for resolved conflict

Fix: https://github.com/rust-lang/rust/commit/f072d3074170f1e70a6f6a1b309fa43f62c25a3c

# Rationale
File: compiler/rustc_parse/src/parser/expr.rs, `CondChecker::visit_expr` (ExprKind::Let arm).
Fix hunk `@@ -4073,14 +4073,18 @@ impl MutVisitor for CondChecker<'_>` added a `match reason { NotSupportedOr(or_span) => emit OrInLetChain{span: or_span}, _ => ExpectedExpressionFoundLet }`.
Re-injected bug: removed that match, so `||` after a `let` again emits the generic "expected expression, found `let` statement" error at the let span. The OrInLetChain diagnostic struct (in diagnostics.rs) and ftl entry are left in place (unused), as the other fix hunks only add them.
