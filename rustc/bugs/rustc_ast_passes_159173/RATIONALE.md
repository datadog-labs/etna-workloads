# Adapted injection for Add allow_list checking for eii implementation attributes

Fix: https://github.com/rust-lang/rust/commit/4e53ac1907b713026674cf110961e2f4fe844f06

# Rationale
One hunk: compiler/rustc_ast_passes/src/ast_validation.rs, `visit_item` (ItemKind::Fn arm): removed the call
`self.check_eii_impl_attrs(&item.attrs, eii_impl);` after visiting the eii_macro_path.
Re-expresses fix hunk `@@ -1391,6 +1433,7 @@ impl Visitor<'_> for AstValidator<'_>` which added
`self.check_eii_impl_attrs(&item.attrs, eii_impls);` for functions. Before the fix, EII fn implementations
had no allowlist check (so no_mangle/export_name/track_caller etc. were accepted there).
The Static call site is left intact.
