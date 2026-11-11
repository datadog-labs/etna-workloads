# Adapted injection for Only prevent field projections into opaque types, not types containing opaque types

Fix: https://github.com/rust-lang/rust/commit/17b313fb5734df8186071d4e30e46673098bb6a9

# Rationale
File: compiler/rustc_hir_typeck/src/expr_use_visitor.rs, fn `cat_projection` (the logic moved from mem_categorization.rs).

Fix hunk `@@ -464,7 +464,7 @@ impl MemCategorizationContext`:
`- if node_ty != place_ty && place_ty.has_opaque_types() {` / `+ ... matches!(place_ty.kind(), ty::Alias(ty::Opaque, ..))`.
In 1.99.1 the fixed form is `structurally_resolve_type(..., place_ty).is_opaque()`. I restored the buggy condition
`node_ty != place_ty && place_ty.has_opaque_types()`, so types merely containing opaque types (e.g. Foo<impl Future>) get an OpaqueCast projection.
