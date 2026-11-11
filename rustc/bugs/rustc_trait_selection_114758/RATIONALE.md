# Adapted injection for Don't crash when reporting nice region errors for generic const items

Fix: https://github.com/rust-lang/rust/commit/1a1815889164a2d99a4b0734f7a9df68120c9abe

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/nice_region_error/util.rs, fn `find_param_with_region`.
Changed `tcx.hir_fn_decl_by_hir_id(owner_id)?` back to `.unwrap()`. Re-expresses fix hunk
`@@ -64,7 +64,7 @@ pub fn find_param_with_region` (`-let fn_decl = hir.fn_decl_by_hir_id(owner_id).unwrap();` / `+...(owner_id)?;`).
For generic const items (body owner is not a fn) this ICEs instead of returning None.
The named_anon_conflict.rs hunk was only a refactor (no behaviour change), not re-injected.
