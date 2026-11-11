# Adapted injection for lint/ctypes: allow `()` within types

Fix: https://github.com/rust-lang/rust/commit/24f90fdd2654e9c5437a684d3a72a4e70826a985

# Rationale
File: compiler/rustc_lint/src/types/improper_ctypes.rs, fn `visit_variant_fields` (moved from types.rs `check_variant_for_ffi`).

1. Removed the arm `FfiUnsafe { ty, .. } if ty.is_unit() => false` in the field loop and re-expressed the transparent-newtype branch as a plain `return self.visit_type(...)`. Re-expresses fix hunk `@@ -1027,6 +1008,8 @@` (added "`()` fields are FFI-safe!" arm) and `@@ -1010,14 +986,19 @@` (the `match ... FfiUnsafe { ty, .. } if ty.is_unit() => ()` in the transparent branch). Result: `()` fields in structs are flagged FFI-unsafe again.

The is_unit_or_equivalent hunks no longer exist in 1.99.1 (already restructured), so were not touched.
