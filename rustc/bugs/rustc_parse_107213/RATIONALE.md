# Adapted injection for Add suggestion to remove if in let...else block

Fix: https://github.com/rust-lang/rust/commit/a8b77cfe5464e29b25389593ced9d080bf0dd6c8

# Rationale
File: compiler/rustc_parse/src/parser/expr.rs, fn parse_expr_if (the `self.token.is_keyword(kw::Else)` branch, "Parse then block").
Fix hunk `@@ -2279,9 +2280,15 @@`: added `let_else_sub = matches!(cond.kind, ExprKind::Let(..)).then(|| IfExpressionLetSomeSub{..})` and passed it to IfExpressionMissingThenBlock. Re-injected bug: let_else_sub is always `None`, so the "remove the `if`" help is never emitted (parent behaviour). The struct/ftl additions remain, unused.
