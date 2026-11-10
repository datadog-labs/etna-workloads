# Adapted injection for Don't suppress lint type_alias_bounds for ty aliases containing inherent assoc tys

Fix: https://github.com/rust-lang/rust/commit/63a54d93be33bb1c0357c48532df778f6f2a416b

# Rationale
File: compiler/rustc_lint/src/builtin.rs, `TypeAliasBounds::check_item`.
Re-expresses fix hunk `@@ -1425,30 +1425,27 @@ impl TypeAliasBounds` which removed the early return
`if ty.has_inherent_projections() { return; }` ("Bounds of type aliases that contain ... inherent projections are respected")
and replaced it with a NOTE saying TAB should still trigger. I replaced the NOTE with the early return again, written as
`ty.has_type_flags(ty::TypeFlags::HAS_TY_INHERENT)` (the helper `has_inherent_projections` removed in the visit.rs hunk no longer exists, so the flag check is inlined; the `ty` variable already exists in 1.99.1).
