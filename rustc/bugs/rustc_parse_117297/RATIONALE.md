# Adapted injection for Give a better diagnostic for missing parens in Fn* bounds

Fix: https://github.com/rust-lang/rust/commit/904aceec7d9595d49b1ce6e9e8a04f64f6a814fd

# Rationale
File: compiler/rustc_parse/src/parser/function.rs, fn `parse_fn_body_missing`-style handler (the `self.token == token::RArrow` branch, error recovery for missing fn body).
Fix hunk re-expressed: item.rs `@@ -2278,6 +2278,18 @@` which added `if self.token.kind == token::RArrow { ... err.subdiagnostic(errors::FnTraitMissingParen {..}) }`.
In 1.99.1 that logic moved to function.rs; I removed the `if let Some(fn_trait_span) = fn_trait_span { err.subdiagnostic(FnTraitMissingParen{..}) }` branch (replaced with `let _ = fn_trait_span;`), so `F: FnOnce -> ()` no longer gets the "`Fn` bounds require arguments in parentheses" label/suggestion and falls into the misplaced-return-type diagnostic instead.
