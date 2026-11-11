# Adapted injection for Add suggestion for removing invalid path separator `::` in function definition.

Fix: https://github.com/rust-lang/rust/commit/d0165956fe070d12090896aa5546e509045471eb

# Rationale
File compiler/rustc_parse/src/parser/generics.rs, fn `parse_generics`: removed the block
`if self.eat_noexpect(&token::PathSep) { emit_err(InvalidPathSepInFnDefinition{span: prev_token.span}) }`
that the fix added at `@@ -269,6 +269,13 @@ ... pub(super) fn parse_generics`. (Error struct and ftl message left in place, now unused; on 1.99.1 the struct lives in diagnostics.rs.)
