# Adapted injection for Don't resolve generic instances if they may be shadowed by dyn

Fix: https://github.com/rust-lang/rust/commit/a30ad3a5a6362c31b16d3bd3f21bbae1315bfaec

# Rationale
File: compiler/rustc_ty_utils/src/instance.rs, fn resolve_associated_item (ImplSource::UserDefined arm).
Removed the HACK block (`if !self_ty.is_known_rigid() { ... no Self: Sized clause => return Ok(None) }`),
re-expressing the fix hunk `@@ -141,11 +141,34 @@ fn resolve_associated_item` which added it. Without it, generic
instances that may be shadowed by the builtin `dyn Trait` impl get resolved to the blanket impl (issue 114928).
The `is_known_rigid` helper (sty.rs hunk `@@ -2945,6 +2945,33 @@`) is left in place (now unused here; still exists in 1.99.1 on TyKind).
