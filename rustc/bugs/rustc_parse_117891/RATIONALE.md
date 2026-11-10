# Adapted injection for Recover `dyn` and `impl` after `for<...>`

Fix: https://github.com/rust-lang/rust/commit/a8a2ee4e8f5e3c20c826d2cce6d500fb9bedfdd0

# Rationale
File compiler/rustc_parse/src/parser/ty.rs, fn parse_ty_common, `for` branch.
Re-expresses fix hunk `@@ -299,9 +300,42 @@` in ty.rs: removed the
`if self.may_recover() && (self.eat_keyword_noexpect(kw::Impl) || ...Dyn)` recovery block
(TransposeDynOrImpl error, conversion to dyn/impl TyKind), leaving only the original
`parse_path` + `parse_remaining_bounds_path` path. So `for<'a> dyn Trait` is no longer recovered.
The diagnostics (errors.rs / ftl) are left in place (now unused in this path); those hunks only add the diagnostic.
