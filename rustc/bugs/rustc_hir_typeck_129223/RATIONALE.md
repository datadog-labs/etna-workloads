# Adapted injection for Fix wrong argument for `get_fn_decl`

Fix: https://github.com/rust-lang/rust/commit/da7dd434c8086378a44ed2c379050dbe5c01a5d7

compiler/rustc_hir_typeck/src/coercion.rs, CoerceMany::report_return_mismatched_types (~line 2051):
get_fn_decl(block_or_return_id) -> get_fn_decl(fcx.tcx.parent_hir_id(block_or_return_id)),
re-expressing fix hunk `@@ -1859,7 +1859,7 @@` which changed `fcx.get_fn_decl(parent_id)` to `fcx.get_fn_decl(block_or_return_id)`. (In 1.99.1 `parent_id` is gone; the parent HirId is computed inline.)
