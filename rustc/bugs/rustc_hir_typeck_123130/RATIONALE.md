# Adapted injection for Load missing type of impl associated constant from trait definition

Fix: https://github.com/rust-lang/rust/commit/804c0476575e891aa47131d67cbb3b6c21682abf

Hunk: compiler/rustc_hir_typeck/src/lib.rs, `infer_type_if_missing` (moved from `typeck_with_fallback` in 1.99.1).
Fix hunk `@@ -192,10 +192,20 @@ fn typeck_with_fallback`: added a branch so that when an impl assoc const has a `_`/missing type
(`opt_associated_item ... AssocKind::Const ... trait_item_def_id` -> `tcx.type_of(trait_item).instantiate(tcx,args)`), the type is
loaded from the trait definition. I removed that branch, so a fresh infer var is always used (`Some(fcx.next_ty_var(span))`), the pre-fix behaviour.
