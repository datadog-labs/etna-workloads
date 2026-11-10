# Adapted injection for Handle attempts to have multiple `cfg`d tail expressions

Fix: https://github.com/rust-lang/rust/commit/a16722d2210caa5eea941ffa20837859e249fd05

# Rationale
File: compiler/rustc_parse/src/parser/stmt.rs, fn parse_full_stmt.
Removed the match arm `StmtKind::Expr(expr) if expr_requires_semi_to_be_stmt(expr) && !expr.attrs.is_empty() && !matches!(self.token.kind, Eof|Semi|CloseBrace)` that calls `attr_on_non_tail_expr` (the fix's stmt.rs hunk `@@ -617,6 +617,20 @@`, "The user has written `#[attr] expr` which is unsupported. (#106020)"). Without it, the generic recovery emits the old plain "expected `;`" error without the cfg/block suggestions. The helper in diagnostics.rs is left in place but is now unused by the parser path (its fn is still compiled; dead-code is tolerated as it builds).
