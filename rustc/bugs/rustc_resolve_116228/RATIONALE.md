# Adapted injection for resolve: skip underscore character during candidate lookup

Fix: https://github.com/rust-lang/rust/commit/cfb819fa7e7dd16e756eca6d19ac78c7635436bd

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs (moved from diagnostics.rs), closure in `lookup_import_candidates_from_module`.
Removed the `if ident.name == kw::Underscore { return; }` check in the `for_each_child` closure, re-expressing the fix hunk
`@@ -1169,6 +1169,10 @@ impl<'a, 'tcx> Resolver<'a, 'tcx>` (which added that check). Underscore-named re-exports (`pub use X as _`) are again visited as import candidates.
