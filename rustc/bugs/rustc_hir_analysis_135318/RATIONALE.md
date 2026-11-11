# Adapted injection for Rework rustc_dump_vtable

Fix: https://github.com/rust-lang/rust/commit/08d7e9dfe510196c3437662aaf1c5e6915941f94

# Rationale
Bug: before the fix, `#[rustc_dump_vtable]` was only honoured on traits and dumped from inside the `vtable_entries` query; the fix moved it to a dedicated pass (`collect::dump::vtables`) working on impls / dyn type aliases.

1. `compiler/rustc_hir_analysis/src/lib.rs` `check_crate`: removed `collect::dump::vtables(tcx);` — re-expresses fix hunk `@@ -152,11 +152,14 @@ pub fn check_crate` (`+ collect::dump::vtables(tcx);`).
2. `compiler/rustc_hir_analysis/src/collect/dump.rs`: added `#[allow(dead_code)]` to `vtables` (now unused) — keeps build warning-free; relates to hunk `@@ -87,3 +88,82 @@` adding `pub(crate) fn vtables`.
3. `compiler/rustc_trait_selection/src/traits/vtable.rs`: re-added `dump_vtable_entries` and, at the end of `vtable_entries`, `if find_attr!(tcx, trait_ref.def_id, RustcDumpVtable(..)) { dump_vtable_entries(...) }` — re-expresses hunks `@@ -192,15 +191,6 @@` (removed `fn dump_vtable_entries`) and `@@ -317,11 +307,6 @@ fn vtable_entries` (removed `if tcx.has_attr(.., sym::rustc_dump_vtable)`). Diagnostic is emitted via `span_err` with a plain string instead of the removed `DumpVTableEntries` struct/ftl (those files moved in 1.99.1).
