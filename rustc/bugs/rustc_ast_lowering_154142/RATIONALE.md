# Adapted injection for Eliminate usage of AST from generics creation

Fix: https://github.com/rust-lang/rust/commit/1d325ce4367f5a3c0bfd68859af8752e9ea61885

# Rationale
File: compiler/rustc_ast_lowering/src/delegation/generics.rs, generics-param creation for `GenericParamDefKind::Const` (in the delegation generics lowering, ~line 580).
1.99.1 builds the const param's type as `hir::TyKind::InferDelegation(hir::InferDelegation::DefId(p.def_id))`, so the type is inferred via `type_of(def_id)`. This re-expresses the fix hunk `@@ -3765,12 +3758,21 @@ pub struct DelegationGenerics` in hir.rs, which added `InferDelegation::DefId` ("Infer the type of this DefId ... used for const types propagation"), and its use in hir_ty_lowering `lower_delegation_ty`. Reverting to the pre-fix behaviour: the const param type is not propagated from the parent def (now a plain `TyKind::Infer(())`), so the const param type is wrong or erroring for delegated generics, and the ICE-tests' expected output changes.
