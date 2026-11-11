# Adapted injection for AsyncDrop trait without sync Drop generates an error

Fix: https://github.com/rust-lang/rust/commit/eee2d7b1016d6f2743c5f61989b28e05fefd9aff

# Rationale
File: compiler/rustc_hir_analysis/src/check/mod.rs, fn `adt_destructor`.
Re-expresses hunk `@@ -113,7 +113,15 @@ pub fn provide` of fix.diff: removed the
`let dtor = ...; if dtor.is_none() && tcx.features().async_drop() { ... emit_err(AsyncDropWithoutSyncDrop) } dtor`
and restored the original `tcx.calculate_dtor(def_id, always_applicable::check_drop_impl)`.
So an AsyncDrop impl without Drop impl no longer errors. (The error struct/ftl remain, unused-but-harmless; in 1.99.1 they live in diagnostics.rs.)
