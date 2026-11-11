# Adapted injection for [RFC-3086] Restrict the parsing of `count`

Fix: https://github.com/rust-lang/rust/commit/6395dc2cde4421a4d74a8e01dd253957b3f96844

# Rationale
compiler/rustc_expand/src/mbe/metavar_expr.rs, `parse_count`: removed the check
`if iter.peek().is_none() { return Err(... "`count` followed by a comma must have an associated index indicating its depth") }`
after `try_eat_comma`. Re-expresses fix hunk `@@ -93,7 +93,17 @@ fn parse_count` (which added `if iter.look_ahead(0).is_none() { return Err(...) }`). Now `count($t,)` silently gets depth 0.
