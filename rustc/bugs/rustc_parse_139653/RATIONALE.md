# Adapted injection for Handle a negated literal in `eat_token_lit`.

Fix: https://github.com/rust-lang/rust/commit/d25c8a8ade05384e9ca84866be8672a97896826d

# Rationale
File compiler/rustc_parse/src/parser/expr.rs, fn `Parser::eat_token_lit` (closure `check_expr`, which in 1.99.1 is shared by the Literal and Expr metavar arms).
Removed the `else if let ExprKind::Unary(UnOp::Neg, inner) = &expr.kind && inner is Lit { None }` branch, so a reparsed negated literal hits the panic.
Re-expresses the fix hunk `@@ -2166,10 +2166,15 @@` which added that Neg-literal -> `None` branch in place of the unconditional `panic!("didn't reparse an expr")`.
