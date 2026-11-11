# Adapted injection for Recover and suggest use `;` to construct array type

Fix: https://github.com/rust-lang/rust/commit/ed88af21637ff3677100fd26f8db354cd6134ad4

# ty.rs, `parse_array_or_slice_ty` (compiler/rustc_parse/src/parser/ty.rs)
Re-expresses the fix hunk `@@ -575,14 +575,69 @@`: restored the pre-fix
`else { self.expect(exp!(CloseBracket))?; TyKind::Slice(elt_ty) }` in place of
`else if self.eat(CloseBracket) {Slice} else { self.maybe_recover_array_ty_without_semi(elt_ty)? }`,
and removed the added `maybe_recover_array_ty_without_semi` function (which would otherwise be dead code).
So `[u8, 5]` / `[u8 5]` no longer recover with a `;` suggestion.
