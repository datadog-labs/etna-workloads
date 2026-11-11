# Adapted injection for Fix the issue of wrong diagnosis for extern pub fn

Fix: https://github.com/rust-lang/rust/commit/f25463e8483d8dcfb64cda4e96d5b4fbd11a19c8

# Rationale
File: compiler/rustc_parse/src/parser/function.rs, fn `check_fn_front_matter`.
Re-expresses the fix hunk `@@ -2182,7 +2182,11 @@ impl<'a> Parser<'a>` in item.rs (`extern ABI fn` check), which added
`|| (self.may_recover() && look_ahead(2, is_keyword(kw::Pub)) && look_ahead(3, is Fn))`.
In 1.99.1 that logic lives in function.rs (generalised to ALL_QUALS); I removed the whole recovery branch, so
`extern "C" pub fn` is no longer recognised as fn front matter and the "expected `fn`, found `pub`" diagnostic is lost.
