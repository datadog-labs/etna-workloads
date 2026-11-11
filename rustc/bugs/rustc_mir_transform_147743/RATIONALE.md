# Adapted injection for show packed alignment in mir_transform_unaligned_packed_ref

Fix: https://github.com/rust-lang/rust/commit/566a86b02fc81447d922a1bf0a40648466b73dc5

# Rationale
Diagnostics moved from messages.ftl/errors.rs to inline strings in `compiler/rustc_mir_transform/src/diagnostics.rs` in 1.99.1.

1. `diagnostics.rs`, `UnalignedPackedRef` attrs: restored old message "reference to packed field is unaligned" and the old note ("packed structs are only aligned by one byte..."). Re-expresses the fix hunk in messages.ftl `@@ -69,8 +69,11 @@` (`mir_transform_unaligned_packed_ref = reference to field of packed {$ty_descr} ...`).
2. `diagnostics.rs`, `UnalignedPackedRef` struct: removed `ty_descr` and `align` fields (fix hunk `@@ -99,6 +99,8 @@` in errors.rs).
3. `check_packed_ref.rs`, `visit_place`: no longer passes `ty_descr: adt.descr(), align: pack.bytes()` to `emit_err` (fix hunk `@@ -48,7 +50,11 @@`); the pattern bindings are renamed `_adt, _pack` to avoid unused warnings. The util refactor (`place_unalignment`) was left as is, since it is behaviour-neutral.
