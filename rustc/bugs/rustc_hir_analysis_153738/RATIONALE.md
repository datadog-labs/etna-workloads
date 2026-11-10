# Adapted injection for Don't look for non-type-level assoc consts when checking trait object types

Fix: https://github.com/rust-lang/rust/commit/f8bce56b3966c8784060ce875a51f65d18ac659b

In 1.99.1 the fix's `is_type() || is_const()` -> `is_type() || is_type_const()` change became `.filter(|item| item.can_have_equality_constraint(tcx))` (which excludes non-type-level consts unless generic_const_args). I reverted the three call sites to the old behaviour: `item.is_type() || matches!(item.kind, ty::AssocKind::Const { .. })`.
- rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs (lower_trait_object_ty, ordered_associated_items): fix hunk `@@ -230,8 +230,9 @@` (`.filter(|item| item.is_type() || item.is_type_const())`).
- rustc_middle/src/ty/sty.rs (Ty::dyn vtable/projection count): hunk `@@ -753,7 +753,7 @@`.
- rustc_sanitizers/.../transform.rs (trait_object_ty): hunk `@@ -239,7 +239,7 @@`.
The assoc.rs hunk (rename is_const -> is_type_const) needs no change; helper already exists.
