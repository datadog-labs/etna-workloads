# Adapted injection for Fix const items not being allowed to be called `r#move` or `r#static`

Fix: https://github.com/rust-lang/rust/commit/8a02724b9d0bf3a9e449a04c2d7efaa8a0521e1b

# Hunk: compiler/rustc_parse/src/parser/mod.rs, `Parser::check_const_closure`
Changed `token::Ident(kw::Move | kw::Use | kw::Static, IdentIsRaw::No)` to `token::Ident(kw::Move | kw::Use | kw::Static, _)`.
Re-expresses fix hunk `@@ -754,9 +754,9 @@` which added `IdentIsRaw::No` to `token::Ident(kw::Move | kw::Static, _)`.
Effect: `const r#move`/`const r#static` is treated as a const closure again.
The symbol.rs hunk was only a comment, so there is nothing to revert.
