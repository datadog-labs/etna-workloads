# Adapted injection for diagnostics: avoid wrong `unused_parens` on `x as (T) < y`

Fix: https://github.com/rust-lang/rust/commit/62835c953190e7c6cadac1557156a47753a2a913

# Rationale
compiler/rustc_lint/src/unused.rs, `UnusedParens::check_ty` (EarlyLintPass): removed the early return
`if let TyKind::Paren(_) = ty.kind && Some(&ty.id) == self.parens_in_cast_in_lt.last() { return; }`.
Re-expresses the last hunk of fix.diff (`@@ -1141,6 +1163,11 @@ impl EarlyLintPass for UnusedParens`), which added exactly that check
so `x as (T) < y` is not linted. The push/pop bookkeeping (check_expr/check_expr_post) is left in place, but now unused, so the lint wrongly fires.
