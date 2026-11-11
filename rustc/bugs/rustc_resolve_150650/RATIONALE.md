# Adapted injection for Forbid generic parameters in types of #[type_const] items

Fix: https://github.com/rust-lang/rust/commit/46bb414d69749ad7afe3ea8e0e4fd09ae7fe3d6b

All in compiler/rustc_resolve/src/late.rs. The fix wrapped `visit_ty(ty)` of `#[type_const]` items in
ConstParamTy ribs (so generic params in the type are rejected) unless generic_const_parameter_types is on.
In 1.99.1 this is keyed on `ConstItemKind::TypeConst`. I removed the conditional, restoring plain `this.visit_ty(ty)` in three places,
matching fix hunks `@@ -2855`/`-2874` (resolve_item, ItemKind::Const), `@@ -3213`/`-3227` (resolve_trait_items AssocItemKind::Const),
and `@@ -3422`/`-3458` (resolve_implementation AssocItemKind::Const).
