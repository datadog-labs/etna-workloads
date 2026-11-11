# Adapted injection for Suggest add bounding value for RangeTo

Fix: https://github.com/rust-lang/rust/commit/0b45ab398704e75371f184d410c565dc3250681d

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn report_no_match_method_error.
Removed the call `self.suggest_bounds_for_range_to_method(&mut err, source, item_ident);`
re-expressing fix hunk `@@ -1079,6 +1079,7 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>` (which added that call). The helper (hunk 2) remains but is unused, so no bounded-range suggestion is emitted for `(..4).rev()`.
