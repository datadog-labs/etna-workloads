# Adapted injection for Fix suggestion when shorthand self has erroneous type

Fix: https://github.com/rust-lang/rust/commit/05c34cc5ed35dbf32f83e2eaa0ebbda4c4953294

# Rationale
File: compiler/rustc_parse/src/parser/function.rs, fn parse_self_param (the `token::And` arm).
Re-expresses fix hunk `@@ -2978,7 +3004,9 @@` in item.rs (the code has since moved to function.rs):
the fix replaced `(eself, expect_self_ident(self), self.prev_token.span)` with a call to
`expect_self_ident_not_typed(self, &eself, eself_lo.until(hi))`, which recovers `: Type` after `&self`/`&mut self`.
I restored the old line, so `&self: Self` no longer gets the "type not allowed for shorthand `self`" recovery.
The helper closure and error types remain (unused closure), as the other hunks only add them.
