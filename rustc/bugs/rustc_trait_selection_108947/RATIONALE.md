# Adapted injection for Use param's real type in try_eval_lit_or_param

Fix: https://github.com/rust-lang/rust/commit/9574f39c2dc6312223fe562c1e04e4344eada316

# Rationale
One hunk: compiler/rustc_trait_selection/src/traits/fulfill.rs, `process_obligation`, `ConstArgHasType` arm, `ConstKind::Param` case.

Fix hunk re-expressed: consts.rs `@@ -135,6 +135,9 @@ impl<'tcx> Const<'tcx>` / `let param_ty = tcx.type_of(def_id).subst_identity();` and
`Some(tcx.mk_const(ty::ParamConst::new(index, name), param_ty))` (was `ty`). The fix used the param's real declared type instead of
the expected type. In 1.99.1 consts carry no type; the declared type is looked up via `param_ct.find_const_ty_from_env`.
The bug is restored by using the expected type `ty` for param consts, so `N: usize` passed where `u8` is expected is no longer
reported ("the constant `N` is not of type `u8`").
The specialize/mod.rs hunk only changed a bug! message, so it was not re-expressed.
