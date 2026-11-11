# Adapted injection for Add implicit sized bound to trait ascription types

Fix: https://github.com/rust-lang/rust/commit/4cebbabd5ce3fdb1444cc7efdb8e07eff52b6652

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn lower_ty, `hir::TyKind::TraitAscription` arm.
Removed the `self.add_implicit_sizedness_bounds(&mut bounds, self_ty, hir_bounds, ImpliedBoundsContext::AssociatedTypeOrImplTrait, hir_ty.span)` call (1.99.1 name of `add_sizedness_bounds`).
Re-expresses fix hunk `@@ -2489,6 +2489,14 @@` which added `self.add_sizedness_bounds(&mut bounds, self_ty, hir_bounds, None, None, hir_ty.span);` before `register_trait_ascription_bounds`.
