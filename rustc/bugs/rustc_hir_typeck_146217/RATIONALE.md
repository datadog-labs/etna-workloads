# Adapted injection for fix ICE when suggesting `::new`

Fix: https://github.com/rust-lang/rust/commit/4ca8078d37c53ee4ff8fb32b4453b915116f25b8

# Rationale
File: compiler/rustc_hir_typeck/src/expr.rs, fn suggesting `::new` assoc fns for private-field struct literals (the `.filter_map` closure).
Re-expresses fix hunk `@@ -2585,12 +2585,11 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>`: the fix replaced
`fn_sig(def_id).skip_binder()` + `normalize_erasing_late_bound_regions(...)` with
`fn_sig(def_id).instantiate(tcx, self.fresh_args_for_item(span, def_id))` + `instantiate_bound_regions_with_erased`.
I restored the old skip_binder/normalize_erasing code, so the impl's generic params are not instantiated with inference vars (ICE with projections / wrong candidates).
