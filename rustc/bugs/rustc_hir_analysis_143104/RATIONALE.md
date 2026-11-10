# Adapted injection for hir_analysis: prohibit `dyn PointeeSized`

Fix: https://github.com/rust-lang/rust/commit/2057423506ea08f35d05f067a2ffe73579afac12

# Rationale
On 1.99.1 the fix's check (`report_pointee_sized_trait_object`, hunk `@@ -80,6 +81,13 @@` in dyn_compatibility.rs, "We don't support `PointeeSized` principals") was superseded: `dyn PointeeSized` is rejected with E0224 because `lower_poly_trait_ref` (hir_ty_lowering/mod.rs) drops `PointeeSized` bounds ("transient"). The oracle stderr expects E0224.

Single hunk, hir_ty_lowering/mod.rs `lower_poly_trait_ref`: the `transient` computation for positive `PointeeSized` bounds now excludes the dyn-lowering context (`OverlappingAsssocItemConstraints::Forbidden`). So `dyn PointeeSized` keeps a `PointeeSized` principal and is no longer rejected, re-creating the pre-fix state in which `dyn PointeeSized` was not prohibited (the fix added the rejection of a PointeeSized principal in dyn_compatibility.rs).
