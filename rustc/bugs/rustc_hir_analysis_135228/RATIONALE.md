# Adapted injection for Normalize field before checking PhantomData in coerce/dispatch impl validation

Fix: https://github.com/rust-lang/rust/commit/3cd75812c818c5e7855f1be8f6a754c9f7a9f0f8

# Rationale
File compiler/rustc_hir_analysis/src/coherence/builtin.rs, two hunks, both re-expressing the fix's hunks
`@@ -260,13 +260,22 @@ fn visit_implementation_of_dispatch_from_dyn` and `@@ -469,8 +478,16 @@ pub(crate) fn coerce_unsized_info`:
the fix added `try_normalize_erasing_regions(...)` of the field type before `.is_phantom_data()`.
- visit_implementation_of_dispatch_from_dyn (coerce-fields filter_map): reverted to checking `tcx.type_of(field.did).instantiate_identity().is_phantom_data()` without normalizing.
- coerce_unsized_info (diff_fields filter_map): same revert.
A PhantomData hidden behind a projection (`<PhantomData<T> as Mirror>::Assoc`) is then no longer ignored.
