# Adapted injection for mgca: Type-check fields of tuple expr const args

Fix: https://github.com/rust-lang/rust/commit/1c2cb16e8232843004ee277c1819d2d5e1c03e11

# Rationale
File compiler/rustc_trait_selection/src/traits/wf.rs, `WfPredicates::visit_const`, `ConstKind::Value` arm.
Removed the `ty::Tuple(field_tys) => { ... ConstArgHasType(field_val, field_ty) ... }` match arm, re-expressing the fix hunk
`@@ -1053,27 +1053,49 @@` which added `ty::Tuple(field_tys) => { let field_vals = val.to_branch(); ... }`.
Tuple const-arg fields are no longer type-checked (the Adt and Array arms stay). The valtree.rs hunk was doc-only.
