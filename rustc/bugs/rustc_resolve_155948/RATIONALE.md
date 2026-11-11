# Adapted injection for Fix order-dependent visibility diagnostics

Fix: https://github.com/rust-lang/rust/commit/f7c62f533e8df7d1b9b01d93d4ed501c2f1a2520

# Rationale
All changes are in compiler/rustc_resolve/src/build_reduced_graph.rs.

1. `DefCollector::resolve_visibility` — re-expresses the hunk `@@ -362,106 +468,15 @@ ... fn resolve_visibility`.
   The fix pushes a `DelayedVisResolutionError` and returns Public; the bug restores the old eager
   `try_resolve_visibility(.., true).unwrap_or_else(|err| { self.r.report_vis_error(err); Public })`.
   Errors are reported immediately, so they depend on the order of resolution, and the delayed list is left empty.
2. `Resolver::try_resolve_visibility` — re-expresses the removed lines in the same hunk
   (`if finalize { self.r.record_partial_res(id, PartialRes::new(res)); }` placed before `if module.is_normal()`).
   The record is moved back to just after `module.res()`, so it runs even for non-module results and inaccessible ancestors.
