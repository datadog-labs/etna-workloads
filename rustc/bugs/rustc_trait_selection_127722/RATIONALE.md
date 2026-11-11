# Adapted injection for Split part of `adt_const_params` into `unsized_const_params`

Fix: https://github.com/rust-lang/rust/commit/d0c11bf6e3fea61711af107c896a763a71606340

# Rationale
One hunk: compiler/rustc_trait_selection/src/traits/misc.rs, `type_allowed_to_implement_const_param_ty`.
The `if need_unstable_feature_bound { ... ClauseKind::UnstableFeature(sym::unsized_const_params) ... return Err(UnsizedConstParamsFeatureRequired) }` check is disabled (`if false && ...`).
Re-expresses the fix hunk `@@ -121,14 +102,23 @@ type_allowed_to_implement_const_param_ty`, which gated `ty::Slice | ty::Ref | ty::Str` on
`unsized_const_params` and returned `UnsizedConstParamsFeatureRequired` otherwise. Without it, references, slices and str are accepted
as const param types without `unsized_const_params`, as in the pre-split behaviour where `adt_const_params` covered them.
The 1.99.1 code structure differs from the fix (no UnsizedConstParamTy trait; the gate is an UnstableFeature clause), so this is the closest equivalent.
