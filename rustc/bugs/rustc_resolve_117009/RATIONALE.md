# Adapted injection for on unresolved import disambiguate suggested path if it would collide

Fix: https://github.com/rust-lang/rust/commit/4aaf8e03e1a1e2a53e95196569213baafc421b2b

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs, fn `lookup_import_candidates` (extern prelude loop).
The code moved from diagnostics.rs. The fix hunk `@@ -1340,13 +1340,43 @@` added `needs_disambiguation` and
`if needs_disambiguation { crate_path.push(ast::PathSegment::path_root(DUMMY_SP)); }`, so suggested paths get a `::` prefix
when an in-scope item collides with the crate name. Re-injection: the push is guarded by `false && needs_disambiguation`,
so the global-path prefix is never added (the pre-fix behaviour).
