# Adapted injection for improve error for `impl<..> impl Trait for Type`

Fix: https://github.com/rust-lang/rust/commit/7fe83345ef0204eedd8ac3847a527466f6853c0b

# Rationale
File compiler/rustc_parse/src/parser/item.rs, fn parse_item_impl (trait-impl branch).
Re-expresses the hunk `@@ -603,10 +603,24 @@ impl<'a> Parser<'a>` which replaced the `_ =>` arm (emit ExpectedTraitInTraitImplFoundType)
with `other => { if let TyKind::ImplTrait(_, bounds) = other && let [bound] = ... { emit ExtraImplKeywordInTraitImpl } else {...} }`.
I removed the ImplTrait special case, restoring the `_ =>` arm that always reports "expected a trait, found type".
The diagnostics struct/ftl additions (other hunks) are left in place (now unused by this path).
