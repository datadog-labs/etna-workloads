# Adapted injection for CFI: Erase regions when projecting ADT to its transparent non-1zst field

Fix: https://github.com/rust-lang/rust/commit/c8ae02fb842fcd4b2f3a75e279bd61c141552c55

# Rationale
File: compiler/rustc_sanitizers/src/cfi/typeid/itanium_cxx_abi/transform.rs, `TransformTy::fold_ty` (repr(transparent) ADT branch).
Re-expresses fix hunk `@@ -146,7 +146,7 @@ impl<'tcx> TypeFolder<TyCtxt<'tcx>> for TransformTy<'tcx>`:
`-type_of(field.did).instantiate(..)` / `+erase_regions(field.ty(self.tcx, args))`.
In 1.99.1 the code used `normalize_erasing_regions(fully_monomorphized, field.ty(tcx, args))`; I replaced it with `field.ty(tcx, args).skip_norm_wip()`, so regions are no longer erased when projecting to the transparent non-ZST field (e.g. `Box<dyn Trait + 'static>` keeps `'static`), reproducing the bug.
