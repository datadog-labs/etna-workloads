# Adapted injection for Don't compute name of associated item if it's an RPITIT

Fix: https://github.com/rust-lang/rust/commit/6033e9df02ecc6de27d840f3cab5e788f6b63441

# Rationale
Fix: item.name() was evaluated on RPITIT assoc items (which have no name) before the `is_impl_trait_in_trait` check.

1. compiler/rustc_hir_analysis/src/diagnostics/wrong_number_of_generic_args.rs, `get_unbound_associated_item`: moved `!item.is_impl_trait_in_trait()` out of the first filter into a separate filter *after* the `constraint.ident.name == item.name()` check. Re-expresses hunk `@@ -486,15 +486,15 @@ impl WrongNumberOfGenericArgs` (fix merged `!item.is_impl_trait_in_trait()` before the name comparison; parent had it as a trailing `.filter`).
2. compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, assoc-type trait search (`all_traits_including_private` filter): removed `&& !i.is_impl_trait_in_trait()` so `i.ident(tcx)` is computed on RPITITs. Re-expresses hunk `@@ -1731,9 +1731,9 @@` (`+ && !i.is_impl_trait_in_trait()`).
(The Namespace import hunk is irrelevant.)
