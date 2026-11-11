# Adapted injection for Detect missing `=>` after match guard during parsing

Fix: https://github.com/rust-lang/rust/commit/745c1ea4388864d6a832aeacb9fc3b9db1ab9c2f

# Hunk
compiler/rustc_parse/src/parser/expr.rs, `parse_expr_struct_fields` (struct-literal field recovery):
removed
```
if in_if_guard && close.token_type == TokenType::CloseBrace { return Err(e); }
```
(binding renamed `_in_if_guard` to avoid unused warning). Re-expresses fix hunk
`@@ -3128,6 +3158,26 @@` which added `if in_if_guard && close_delim == Delimiter::Brace { return Err(e); }`.
Without it, struct-literal parse errors inside a match guard are emitted and recovered
instead of propagated to `parse_match_guard_condition`, so the "you might have meant to start a match arm" suggestion is lost and cascading errors return.
