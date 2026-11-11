# Adapted injection for Replace `ItemCtxt::report_placeholder_type_error` `match` with a call to `TyCtxt::def_descr`

Fix: https://github.com/rust-lang/rust/commit/76df2656dfdb385830e83b14abf908544177be22

# Rationale
File: compiler/rustc_hir_analysis/src/collect.rs, `ItemCtxt::report_placeholder_type_error`.
Fix hunk `@@ -277,17 +277,7 @@ impl<'tcx> ItemCtxt<'tcx>` replaced the HIR-node `match` (`Node::Item(it) => it.kind.descr()`, ... `Node::OpaqueTy(_) => "opaque type"`) with `let kind = self.tcx.def_descr(kind_id.into());`.
I re-introduced the HIR-node match. The `descr()` methods on item kinds no longer exist in 1.99.1, so the old strings
("static item", "constant item", "method", "foreign function", ...) are inlined, with `def_descr` as fallback for other kinds.
This yields the old, differing descriptions in placeholder-type diagnostics.
