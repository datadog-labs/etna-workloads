# Adapted injection for Only include associated type bounds for Self:Sized associated types if they are provided

Fix: https://github.com/rust-lang/rust/commit/fd37906477d36968247ddf2db43244af5d54b752

# Rationale
1. compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs (lower_trait_object_ty; file was renamed from dyn_compatibility.rs).
   Re-expresses fix hunks `@@ -204,9 +204,6 @@` (removed `.filter(|item| !tcx.generics_require_sized_self(item.def_id))` on the assoc items list) and `@@ -285,7 +282,11 @@` (moved the check to missing_assoc_types insertion). Reverted to the old behaviour: items whose assoc type has `where Self: Sized` are filtered out up front, so user-provided bindings for them are dropped instead of kept as projection bounds.
2. compiler/rustc_middle/src/ty/sty.rs (Ty::new_dynamic debug assertion). Re-expresses `@@ -723,7 +723,10 @@`: removes the `.filter(... generics_require_sized_self ...)` from projection_count.
