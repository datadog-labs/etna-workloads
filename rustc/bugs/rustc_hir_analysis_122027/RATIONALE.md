# Adapted injection for Uplift some feeding out of associated_type_for_impl_trait_in_impl and into queries

Fix: https://github.com/rust-lang/rust/commit/ebc45c8505c16f3ef3d84875e27728fb9dfe76bc

Re-injects the pre-fix behaviour: the RPITIT trait assoc type's `generics_of` and `type_of` are eagerly fed
inside `associated_type_for_impl_trait_in_trait` instead of being computed by the queries.

- compiler/rustc_ty_utils/src/assoc.rs, `associated_type_for_impl_trait_in_trait`: re-added
  `trait_assoc_ty.type_of(...)` and `trait_assoc_ty.generics_of({...})` (copy opaque generics, trait as parent).
  Re-expresses the hunk `@@ -284,48 +284,8 @@ fn associated_type_for_impl_trait_in_trait(` ("-    // Copy type_of of the opaque." ... "-    trait_assoc_ty.generics_of({"). Also restored the imports (`GenericArgs`, `Ty`) per hunk `@@ -4,7 +4,7 @@`.
- compiler/rustc_hir_analysis/src/collect/generics_of.rs, `generics_of`: removed the
  `if let Some(ImplTraitInTraitData::Trait{..}) = tcx.opt_rpitit_info(..)` synthesis block, per hunk
  `@@ -14,6 +14,43 @@` ("+    // For an RPITIT, synthesize generics ...").
- type_of.rs left unchanged (its Trait branch becomes dead because the value is fed; harmless).
Because generics_of(opaque) is computed while building associated items, a query cycle appears.
