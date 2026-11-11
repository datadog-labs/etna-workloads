# Adapted injection for Rule out `const unsafe impl` from `FnHeader` to correctly parse `const unsafe trait` implementations.

Fix: https://github.com/rust-lang/rust/commit/470e4623db006aeb49504177c51ef04824124319

compiler/rustc_parse/src/parser/function.rs (fn check_fn_front_matter, ~line 348): removed `kw::Impl` from `self.is_keyword_ahead(2, &[kw::Auto, kw::Trait, kw::Impl])`, restoring the parent `&[kw::Auto, kw::Trait]`. Re-expresses the fix hunk `@@ -2942,8 +2942,8 @@` (item.rs in the old tree; the code has moved to function.rs), which added `kw::Impl` to rule out `const unsafe impl`.
