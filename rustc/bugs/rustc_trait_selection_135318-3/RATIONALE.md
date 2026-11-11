# Adapted injection for Do not treat vtable supertraits as distinct when bound with different bound vars

Fix: https://github.com/rust-lang/rust/commit/fdc4bd22b7b8117f4a3864c342773df600f5b956

# Rationale
All hunks are in compiler/rustc_trait_selection/src/traits/vtable.rs. In 1.99.1 the supertrait walk already takes `TraitRef` (the PolyTraitRef -> TraitRef refactor from the fix is in place), so the bug is re-expressed as "late-bound vars are not erased when walking vtable supertraits".

1. `prepare_vtable_segments_inner`, `direct_super_traits_iter`: replaced `tcx.normalize_erasing_late_bound_regions(.., pred).trait_ref` with `pred.skip_binder().trait_ref`.
   Re-expresses fix hunk `@@ fn prepare_vtable_segments_inner` where `tcx.instantiate_bound_regions_with_erased(pred.instantiate_supertrait(..).as_trait_clause()?).trait_ref` replaced the old `unvisited_super_trait.map_bound(|t| t.trait_ref)` (binder kept, supertraits differing in bound vars were distinct).
2. `first_method_vtable_slot` and `supertrait_vtable_slot`: `source_principal` is now `principal.with_self_ty(..).skip_binder()` instead of `tcx.instantiate_bound_regions_with_erased(..)`.
   Re-expresses fix hunks in collector.rs / vtable.rs, `@@ create_mono_items_for_vtable_methods` / `collect_alloc` (`instantiate_bound_regions_with_erased(principal)`), i.e. the point where the principal's bound vars are erased before the vtable layout is computed. Without it the slot computation sees `Supertrait<^0>` and `Supertrait<erased>` as distinct, while the allocation (which erases) merges them, so vtable layout and upcast slot disagree.
