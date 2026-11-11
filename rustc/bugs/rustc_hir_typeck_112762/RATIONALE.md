# Adapted injection for sort the errors from arguments checking so that suggestions are handled properly

Fix: https://github.com/rust-lang/rust/commit/0b20096eff0e12690e63be97647b50383402e57c

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/arg_matrix.rs, fn `ArgMatrix::find_errors`.
Removed the final `errors.sort();` (and its comment "sort errors with same type by the order they appear in the source ... see #112507"). This re-expresses the fix hunk `@@ -376,6 +376,13 @@ impl<'tcx> ArgMatrix<'tcx>` which added `errors.sort_by(...)` ordering Missing/Extra errors by index before `return (errors, matched_inputs)`. In 1.99.1 that is a derived-Ord `errors.sort()`. Without it errors are unsorted, so the extra-argument suggestion is wrong.
The other fix hunks (import reorder, comment tweak) are cosmetic and not reproduced.
