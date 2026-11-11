# Adapted injection for resolve: Do not finalize shadowed bindings

Fix: https://github.com/rust-lang/rust/commit/f89660e4aa018401ca993f0df190e5f4c4a6799b

# Rationale
File compiler/rustc_resolve/src/ident.rs, fn resolve_ident_in_scope_set_inner: the call to resolve_ident_in_scope passed
`if innermost_results.is_empty() { finalize } else { None }` (shadowed decls not finalized); now passes `finalize` always,
so shadowed bindings are finalized (marked used / non-speculatively loaded) again.
This re-expresses the fix's intent ("resolve: Do not finalize shadowed bindings"), i.e. the hunks `@@ -492,14 +492,13 @@` / `@@ -557,8 +556,10 @@`
(`finalize_scope!()` which returned None for shadowed results). In 1.99.1 that macro was replaced by the inline condition.
