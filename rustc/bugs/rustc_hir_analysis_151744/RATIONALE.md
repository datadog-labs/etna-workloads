# Adapted injection for fix refining_impl_trait suggestion with return_type_notation

Fix: https://github.com/rust-lang/rust/commit/bcde3fc78018524e70284166f4b712e4f73ba9a3

# Rationale
1. compiler/rustc_hir_analysis/src/check/compare_impl_item/refine.rs, `report_mismatched_rpitit_signature`: removed the `return_ty_suggestion = with_no_trimmed_paths!(with_types_for_signature!(format!("{return_ty}")))` computation and the import, and pass `return_ty` (a `Ty`) directly again. Re-expresses hunks `@@ -332,6 +333,17 @@`, `@@ -342,7 +354,7 @@` (`return_ty: return_ty_suggestion` -> `return_ty`) and the import hunk `@@ -6,6 +6,7 @@`. Types print in non-signature mode, so RTN prints `impl Trait { T::method(..) }`.
2. compiler/rustc_hir_analysis/src/diagnostics.rs (errors.rs was renamed), `ReturnPositionImplTraitInTraitRefined`: struct gets `<'tcx>` and `return_ty: Ty<'tcx>` again. Re-expresses fix hunks `@@ -1122,7 +1122,7 @@` and `@@ -1136,7 +1136,7 @@` in errors.rs.
