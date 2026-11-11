# Adapted injection for Suppress lint type_alias_bounds for ty aliases containing const projections under GCE

Fix: https://github.com/rust-lang/rust/commit/a8b3dfd25336dc12f17da23a0ed7004a4ebee234

# Rationale
compiler/rustc_lint/src/builtin.rs, `TypeAliasBounds::check_item`: removed the early return
(`HAS_CONST_ALIAS` type flag + `generic_const_exprs` feature => return). This re-expresses the fix hunk
`@@ -1437,6 +1437,16 @@ impl<'tcx> LateLintPass<'tcx> for TypeAliasBounds` which added
`if ty.has_type_flags(HAS_CT_PROJECTION) && features().generic_const_exprs { return; }`.
Without it the lint fires for such aliases again.
