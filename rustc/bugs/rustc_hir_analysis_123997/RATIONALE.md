# Adapted injection for Delay span bug when Self resolves to DefKind::{Mod,Trait}

Fix: https://github.com/rust-lang/rust/commit/6288a721f5ea59a59b4304a7b70c92d7755e8aa8

# Hunks

1. compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, `lower_resolved_ty_path`:
   removed the `Res::Def(..) => { assert_eq!(... Some(kw::SelfUpper) ...); Ty::new_error(span_delayed_bug("incorrect resolution for `Self`")) }` arm,
   so `Self` resolving to a Mod/Trait hits `span_bug!("unexpected resolution")`.
   Re-expresses fix hunk `@@ -1879,6 +1879,17 @@ impl<'tcx> dyn HirTyLowerer<'tcx>` (the added `Res::Def(..)` arm).

2. compiler/rustc_resolve/src/ident.rs, `resolve_ident_in_scope_set_inner`: the early return for path-segment keywords
   now exempts `Self` (`&& ident.name != kw::SelfUpper`). In 1.99.1 the resolver otherwise turns `Self` into Res::Err
   before it reaches HIR lowering, so hunk 1 alone is unobservable; this restores the old state where `mod Self {}`/`trait Self {}`
   resolve `Self` to a DefKind::Mod/Trait (the precondition the fix's arm handled).
