# Adapted injection for only require sub type relation on field projection types

Fix: https://github.com/rust-lang/rust/commit/6e1d22828505bd582b899d7ecdba21caf3327ea7

# Hunk: compiler/rustc_borrowck/src/type_check/mod.rs, `visit_projection_elem` (ProjectionElem::Field arm)
The field-type check relates the field type from the place with `context.ambient_variance()`. Changed to `ty::Invariant` (equivalent to the old `eq_types`).
Re-expresses fix hunk `@@ -713,8 +715,11 @@ sanitize_projection`: `eq_types(ty, fty, ...)` -> `relate_types(ty, self.get_ambient_variance(context), fty, ...)`. The fix only requires a sub-type relation on field projections; the bug is requiring equality always.
