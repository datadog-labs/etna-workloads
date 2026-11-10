# Adapted injection for Normalize type_const items even with feature `generic_const_exprs`

Fix: https://github.com/rust-lang/rust/commit/7510f747a8599c430a054ba58d53dc8dae1465ee

# Rationale
File: compiler/rustc_trait_selection/src/traits/normalize.rs, `AssocTypeNormalizer::fold_const`.
Re-expresses the fix hunk `@@ -433,7 +433,12 @@ ... fn fold_const`, which added
`&& !matches!(ct.kind(), ... if tcx.is_type_const(uv.def))` so type_const items are normalized even with
generic_const_exprs. I removed that clause, restoring `if tcx.features().generic_const_exprs() || !needs_normalization(..) { return ct; }`.
