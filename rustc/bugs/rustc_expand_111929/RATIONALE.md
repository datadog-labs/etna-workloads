# Adapted injection for Don't print newlines in APITs

Fix: https://github.com/rust-lang/rust/commit/46923753890f04d12e1d9d230c6eb3b8af28bf40

# Rationale
File: compiler/rustc_expand/src/expand.rs, the `visit_ty` in the impl-trait name collector (~line 1872).
The APIT name is now computed here (`insert_impl_trait_name`), not in rustc_ast_lowering as the fix did.
Fix hunk `@@ -1425,7 +1425,16 @@ ... lower` changed `Ident::from_str_and_span(&pprust::ty_to_string(t), span)` to
`pprust::ty_to_string(t).replace('\n', " ")`. I removed the equivalent `.replace('\n', " ")`, so long
APIT names contain newlines again.
