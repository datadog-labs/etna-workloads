# Adapted injection for lint/ctypes: stricter `()` return type checks

Fix: https://github.com/rust-lang/rust/commit/f53cef31f5ea41c9a5ab8e5335637a6873b9f0b5

# Rationale
File: compiler/rustc_lint/src/types/improper_ctypes.rs, fn `visit_type_adt_variant` (transparent-newtype branch).
Removed the arm `FfiUnsafe { ty, .. } if ty.is_unit() => ()` that tolerated a `()` field in a repr(transparent)
newtype, leaving `r => return r`. This re-expresses the fix's removal of
`FfiResult::FfiUnsafe { ty, .. } if is_return_type && ty.is_unit() => {}` (@@ -1373,9 +1391,6 @@, the
"transparent newtype ... generic argument ... `()`" special case) together with the removal of the
`is_unit_or_equivalent` transparent-wrapper handling (hunk @@ -943,6 +943,30 @@). On 1.99.1 the `()`-return logic
lives in the `outer_ty_kind` check, so the transparent-unit handling is the only analogue; with it gone,
`TransparentWrap<()>` returns are flagged as FFI-unsafe, so the mustpass test fails.
