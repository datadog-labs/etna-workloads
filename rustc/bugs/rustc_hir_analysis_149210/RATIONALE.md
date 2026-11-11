# Adapted injection for fix: Do not ICE on normalization failure of an extern static item

Fix: https://github.com/rust-lang/rust/commit/cf4668285f0800f9818e65dc5ad807ea1e268109

# Rationale
File: compiler/rustc_hir_analysis/src/check/wfcheck.rs, fn `check_static_item`.
Re-expresses the fix hunk `@@ -1186,14 +1186,21 @@ pub(crate) fn check_static_item`: removed the `is_structurally_foreign_item` closure
(`struct_tail_raw` with `deeply_normalize` as the normalizer) and restored the old
`forbid_unsized = !is_foreign_item || { let tail = tcx.struct_tail_for_codegen(item_ty, typing_env); !matches!(tail.kind(), ty::Foreign(_)) }`,
which ICEs when normalizing an extern static's struct tail fails.
