# Adapted injection for make `relate`'s const ty assertion use semantic equality

Fix: https://github.com/rust-lang/rust/commit/a85b0101e6a1d7d2a7a51d0e5472c1a1215b3031

# Rationale
In 1.99.1, `Const` no longer has a `ty()` field and `super_relate_consts` / `check_const_param_definitely_unequal` are gone, so the fix cannot be reversed literally. The original bug was that relating consts compared their types with plain `==` (structural equality) instead of semantic equality (`check_const_param_definitely_unequal`, which handles aliases and infer vars).

Hunk changed: `compiler/rustc_type_ir/src/relate.rs`, `structurally_relate_consts`, the `ConstKind::Value` arm. It now rejects two `Value` consts whose `ty()` differ under `!=` (structural), returning `ConstMismatch`.

This re-expresses the fix hunk `@@ -594,25 +593,6 @@ super_relate_consts`, which removed the `a_ty != b_ty` check (structural comparison of `a.ty()` and `b.ty()`). It also re-expresses the `super_combine_consts` hunk `if a.ty() == b.ty() { return; }`, whose semantic fallback is what the fix added. Structural comparison of const types on alias/infer types is the buggy behaviour. Here it surfaces as a spurious mismatch error rather than a delayed ICE.
