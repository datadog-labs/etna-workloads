# Adapted injection for Delegation: fix ICE on duplicated associative items

Fix: https://github.com/rust-lang/rust/commit/b2ed9d0911d010cd6aef2d038a47cb6294f0a443

# Rationale
File: compiler/rustc_ast_lowering/src/item.rs, fn `lower_impl_item`.
Fix hunks: `@@ -978,13 +979,6 @@ fn lower_impl_item_ref` removed
`self.is_in_trait_impl = trait_item_def_id.is_some();` (derived from whether the item resolved to a trait item),
replaced by `self.is_in_trait_impl = trait_ref.is_some();` (`@@ -373,6 +373,7 @@`).
In 1.99.1 the flag is the local `is_in_trait_impl` in `lower_impl_item` (from the parent's def_kind).
I restored the old behaviour: it is true only if `get_partial_res(i.id)` resolves to a def id, so a duplicate
delegation item in a trait impl (which fails to resolve) is lowered as an inherent item, causing the ICE/wrong diagnostics.
