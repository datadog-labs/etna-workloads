# Adapted injection for Test invalid `define_opaques` attributes

Fix: https://github.com/rust-lang/rust/commit/3e4e65ee8b8c5d7a1916fd6377901416f06dca4d

# Hunk: compiler/rustc_ast_lowering/src/item.rs, `lower_define_opaque`
Re-expresses fix hunk `@@ -1683,17 +1683,21 @@ impl<'hir> LoweringContext` which replaced
`.map(|(id,_path)| self.resolver.get_partial_res(*id).unwrap().expect_full_res().def_id().expect_local())`
with a `filter_map` that emits a delayed bug for non-def resolutions and `span_err` for non-local ones.
I restored the old `map` with `.unwrap()...def_id().expect_local()` (keeping the span in the tuple as 1.99.1 requires), so invalid/foreign paths ICE.
