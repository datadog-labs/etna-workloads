# Adapted injection for Fix invalid float literal suggestions when recovering an integer

Fix: https://github.com/rust-lang/rust/commit/80fcd7c40ec46613b130b5d732162ecbfda6c509

Hunk: compiler/rustc_parse/src/parser/expr.rs, `Parser::recover_after_dot`.
Removed the conditions `suffix.is_none_or(|s| s == sym::f32 || s == sym::f64)` and
`symbol.as_str().chars().all(|c| c.is_numeric() || c == '_')` from the let-chain, leaving only the span adjacency check.
This re-expresses fix hunk `@@ -1854,7 +1854,16 @@` which added `suffix.map_or(true, ...) && symbol...all(is_numeric || '_') && self.token.span.hi() == next_token.span.lo()`
in place of the bare `if self.token.span.hi() == next_token.span.lo()`. Now `.0x0` / `.3u32` are wrongly recovered as `0.0x0` floats.
