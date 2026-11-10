# Adapted injection for Recover upon encountering mistyped `Const` in const param def

Fix: https://github.com/rust-lang/rust/commit/41f5a30690884578f697727c38139728131217ea

# Rationale
File: compiler/rustc_parse/src/parser/generics.rs, fn `parse_ty_param`.
Removed the block `if self.may_recover() && ident.name.as_str().to_ascii_lowercase() == kw::Const.as_str() && self.check_ident() { return self.recover_const_param_with_mistyped_const(...) }`.
This re-expresses fix hunk `@@ -43,6 +43,15 @@ impl<'a> Parser<'a> {` (which added that block). Without it, `Const N: u8` is parsed as a type param and gives a generic parse error instead of the recovery. The recovery fn itself (second hunk) is left, now unused.
