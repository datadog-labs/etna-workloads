# Adapted injection for fix: Do not delay E0107 when there exists an assoc ty with the same name

Fix: https://github.com/rust-lang/rust/commit/08362d3e51a2da3eb10fa7a918c5739249873cd8

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/generics.rs, fn `check_generic_arg_count`.
Re-expresses both fix hunks:
- `@@ -535,9 +536,26 @@`: removed the `has_assoc_ty_with_same_name` computation (supertrait_def_ids + probe_trait_that_defines_assoc_item) and restored `all_params_are_binded = true;` instead of `= !has_assoc_ty_with_same_name`. E0107 is again delayed even when an assoc type of the same name exists, so no error is emitted -> ICE on delayed bug.
- `@@ -9,6 +9,7 @@`: removed the now-unneeded `use rustc_trait_selection::traits;`.
