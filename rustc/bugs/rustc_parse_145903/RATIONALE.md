# Adapted injection for add parser check for pointer typo

Fix: https://github.com/rust-lang/rust/commit/ea96b7905626aed8c7a8c25825151d1106983144

File: compiler/rustc_parse/src/parser/ty.rs, `parse_ty_common`: removed the branch
`else if (token is const|mut) && look_ahead(1) == Star { self.parse_ty_c_style_pointer()? }`
(fix hunk `@@ -398,6 +398,10 @@`). Also removed the function `parse_ty_c_style_pointer`
(fix hunk `@@ -579,6 +583,41 @@`). Without them `const* T` / `mut* T` no longer gets the "raw pointer types must be written as `*const T`" diagnostic and fix suggestion.
