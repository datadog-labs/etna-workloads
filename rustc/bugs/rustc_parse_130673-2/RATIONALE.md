# Adapted injection for Parser: recover from `:::` to `::`

Fix: https://github.com/rust-lang/rust/commit/e90e2593ea9c29ff6be20ec38b314fb2d6d927a4

# Rationale
File compiler/rustc_parse/src/parser/path.rs, fn `eat_path_sep` (plus dropped now-unused `PathTripleColon` import).
Re-expresses fix hunk `@@ -272,6 +272,18 @@ impl<'a> Parser<'a>` which added `eat_path_sep` that, after eating `::`,
does `if self.eat_noexpect(&token::Colon) { emit_err(PathTripleColon{..}) }`. Pre-fix behaviour: `::` is eaten
with no `:::` recovery, so `:::` is a parse error. Now `eat_path_sep` is just `self.eat(exp!(PathSep))`.
