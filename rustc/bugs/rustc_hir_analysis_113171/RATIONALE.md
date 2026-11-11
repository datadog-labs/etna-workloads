# Adapted injection for Properly implement variances_of for RPITIT GAT

Fix: https://github.com/rust-lang/rust/commit/a10406318e0888b1356e88ec8866fe260a55e6aa

# Rationale
File: compiler/rustc_hir_analysis/src/variance/mod.rs, fn `variances_of`.
Removed the `DefKind::AssocTy => match tcx.opt_rpitit_info(..) { Some(ImplTraitInTraitData::Trait{opaque_def_id,..}) => return variance_of_opaque(..) ... }` arm.
Re-expresses fix hunk `@@ -51,20 +51,26 @@ fn variances_of`, which added `DefKind::AssocTy => { if let Some(ImplTraitInTraitData::Trait{..}) = tcx.opt_rpitit_info(..) { return variance_of_opaque(..) } }`. Without it, RPITIT GATs hit the "asked to compute variance" span_bug.
