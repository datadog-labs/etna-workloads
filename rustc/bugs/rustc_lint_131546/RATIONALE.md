# Adapted injection for Make unused_parens's suggestion considering expr's attributes

Fix: https://github.com/rust-lang/rust/commit/1e8d6d1ec3cad6bc7d88c0a8a993f69835e8422f

# Hunk: compiler/rustc_lint/src/unused.rs, `emit_unused_delims_expr`
In 1.99.1 the fix's logic moved from `remove_outer_parens`-style code into `emit_unused_delims_expr`.
The `ast::ExprKind::Paren(ref expr)` arm computed the span including attributes (min attr span lo).
Reverted to `expr.span`, re-expressing the fix hunk `@@ -804,7 +804,15 @@ trait UnusedDelimLint` which added
`expr_span_with_attrs` (`expr.span.with_lo(attr_lo)`). Suggestion now drops attributes.
