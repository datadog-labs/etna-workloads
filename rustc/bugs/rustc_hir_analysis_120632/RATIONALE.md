# Adapted injection for For E0223, suggest methods that look similar to the path

Fix: https://github.com/rust-lang/rust/commit/a4cb55f2aca24f3cbf33b025c147d7a894bceefd

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs, fn `report_ambiguous_assoc_item_path`-area caller (the `else` branch after `self_ty.error_reported()`).
The call to `maybe_report_similar_assoc_fn(span, self_ty, hir_self_ty)` is removed (replaced by `let _ = hir_self_ty;`).
This re-expresses the fix hunk `@@ -1373,6 +1374,57 @@ impl<'o, 'tcx> dyn AstConv<'tcx>` in astconv/mod.rs, which added the block
"suggest methods that look similar to the path ... `String::from::utf8` -> `String::from_utf8` (#109195)" before `probe_traits_that_match_assoc_ty`.
In 1.99.1 that block lives in `maybe_report_similar_assoc_fn`; not calling it restores the pre-fix behaviour (no similar-method suggestion for E0223).
