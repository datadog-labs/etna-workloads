# Adapted injection for Parse `const unsafe trait` properly

Fix: https://github.com/rust-lang/rust/commit/b145213ceead916028d84db38f19b4288c85ea15

# Rationale
File: compiler/rustc_parse/src/parser/function.rs, fn `check_fn_front_matter` (the logic moved from item.rs in the fix).
Removed the clause `&& !self.is_keyword_ahead(2, &[kw::Auto, kw::Trait, kw::Impl])` (with its comment "Rule out `const unsafe auto` and `const unsafe trait`..."). This reverses fix hunk `@@ -2664,7 +2664,10 @@` which added `&& !self.is_keyword_ahead(2, &[kw::Auto, kw::Trait])`. As a result `const unsafe trait` is taken as an `fn` front matter again. (The `Impl` part was added later upstream; it is removed along with the clause.)
