# Adapted injection for fix #114275

Fix: https://github.com/rust-lang/rust/commit/7834ffbebe48d05848985634975f543d96cd6145

# Rationale
File: compiler/rustc_sanitizers/src/cfi/typeid/itanium_cxx_abi/transform.rs, `TransformTy::fold_ty`, `ty::Adt` repr(transparent) arm.

The fix hunk (`@@ -824,11 +824,8 @@ fn transform_ty`, `ty::Array(ty0, len)`) made transform_ty evaluate the array length
(`len.eval_target_usize(...)`) because it was an unevaluated const (`1 * 1`) while encoding expected an evaluated one.
In 1.99.1 that evaluation happens via `normalize_erasing_regions` on the transparent struct's field type. I removed that
normalization (use `field.ty(tcx,args).skip_norm_wip()` directly), so the unevaluated array length reaches `encode_ty`,
whose `try_to_target_usize(..).expect("expected monomorphic const in cfi")` panics (ICE) as in the original bug.
