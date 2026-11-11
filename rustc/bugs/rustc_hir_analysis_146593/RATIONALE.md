# Adapted injection for Enforce E0719 only for trait aliases

Fix: https://github.com/rust-lang/rust/commit/389907a17e5c1eecd9fe41a53ca145f42dcd1488

# Re-injected bug
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn lower_poly_trait_ref / the assoc-constraint loop (`dup_constraints`).

Fix hunk re-expressed: `@@ -927,7 +928,7 @@` in mod.rs: `-&mut dup_constraints,` / `+for_dyn.then_some(&mut dup_constraints),`
(and `bounds.rs` `duplicates: Option<&mut ...>`). In 1.99.1 the `for_dyn` flag became
`overlapping_assoc_item_constraints == Forbidden` gating `dup_constraints`. The bug: the E0719 duplicate check
runs for all bounds again (`let mut dup_constraints = Some(FxIndexMap::default());`), not just dyn/trait-alias,
so `impl Iterator<Item: Copy, Item: Send>` wrongly errors E0719.
