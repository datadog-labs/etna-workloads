# Adapted injection for main-termination

Fix: https://github.com/rust-lang/rust/commit/dbc08cfd5798ce91930e11da36145f84bfb7ce9c

# Rationale
File: compiler/rustc_hir_analysis/src/check/entry.rs, fn check_main_fn_ty.
Removed the `infcx.resolve_regions(...)` + `report_region_errors` block (and the now-unused `InferCtxtRegionExt` import) after evaluating the `Termination` bound on main's return type.
Re-expresses fix hunk `@@ -137,8 +134,16 @@ fn check_main_fn_ty` which added `let region_errors = infcx.resolve_regions(main_diagnostics_def_id, param_env, ty::List::empty()); if !region_errors.is_empty() { return Err(...report_region_errors...) }`.
Without it, lifetime requirements on the Termination impl are ignored (issue 148421).
The other hunks (Result-returning refactor) are control-flow only and were left as is.
