# Adapted injection for Fix false positive lint error from no_implicit_prelude attr

Fix: https://github.com/rust-lang/rust/commit/7167e7ce06437ec093e80cc4ff20bf33dbf1fef5

compiler/rustc_resolve/src/check_unused.rs, report_unused_extern_crate_items: removed the
`let module = get_nearest_non_block_module(...); if module.no_implicit_prelude { continue; }` block.
Re-expresses fix hunk `@@ -193,6 +193,16 @@ impl UnusedImportCheckVisitor` (which added that block; 1.99.1 uses owner_def_id instead of local_def_id).
