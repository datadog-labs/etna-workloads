# Adapted injection for Insert RPITITs that were shadowed by missing ADTs that resolve to type error

Fix: https://github.com/rust-lang/rust/commit/a4ac773f62aa0992c4c525b9291302a93b352cc3

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn `collect_return_position_impl_trait_in_trait_tys`.
Removed the trailing loop over `tcx.associated_types_for_impl_traits_in_associated_fn(trait_m.def_id)` that inserted
`Ty::new_error_with_message(.., "missing synthetic item for RPITIT")` for RPITITs not collected (e.g. shadowed by a missing ADT).
This re-expresses the fix hunk `@@ -810,19 +810,37 @@ pub(super) fn collect_return_position_impl_trait_in_trait_tys` (the added
`for assoc_item in tcx.associated_types_for_impl_traits_in_associated_fn(trait_m.def_id) { if !remapped_types.contains_key(..) ...`).
The variable rename hunk is cosmetic and not reproduced.
