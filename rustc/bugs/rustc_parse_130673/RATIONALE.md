# Adapted injection for Parser: recover from `:::` to `::` in delegations

Fix: https://github.com/rust-lang/rust/commit/82482dc3579fd227bbb1226b7b4fc747b01f0def

# Rationale
compiler/rustc_parse/src/parser/item.rs, `parse_path_like_delegation`: replaced `self.eat_path_sep()` with `self.eat(exp!(PathSep))`.
Re-expresses fix hunk `@@ -707,7 +707,7 @@ impl<'a> Parser<'a>`: `-if self.eat(&token::PathSep)` / `+if self.eat_path_sep()`. Without eat_path_sep, `:::` is not recovered to `::` in delegations.
