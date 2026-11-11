# Adapted injection for Preserve EII link through AttrProcMacro token roundtrip and add run-pass test

Fix: https://github.com/rust-lang/rust/commit/b544edd56c70ab3fdcc912375d5910455474a8de

# Hunk: compiler/rustc_expand/src/expand.rs, MacroExpander::expand_invoc (AttrProcMacro token creation)
Removed the match arm `Annotatable::Item(item_inner) if matches!(&item_inner.kind, ItemKind::Fn(f) if f.eii_impl.is_some()) => fake_token_stream_for_item(..)`.
Re-expresses fix hunk `@@ -817,6 +817,18 @@ impl<'a, 'b> MacroExpander` which added that arm (field is `eii_impl: Option` in 1.99.1 rather than `eii_impls`). Without it, the item falls to `item.to_tokens()`, losing the consumed `#[hello]` attribute across the proc-macro roundtrip.
