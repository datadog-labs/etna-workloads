# Adapted injection for next-solver fix const_trait_impl bootstrap

Fix: https://github.com/rust-lang/rust/commit/e8ae1dab12bc1388cd5f6545ccc88297b779f511

1. compiler/rustc_middle/src/ty/context/impl_interner.rs, `fn_is_const` (moved from context.rs): narrowed the debug_assert_matches! back to `DefKind::Fn | DefKind::AssocFn`, dropping the `Ctor(.., CtorKind::Fn)` arm. Re-expresses hunk `@@ -445,7 +445,10 @@ impl Interner for TyCtxt` (adds `DefKind::Ctor(CtorOf::Struct, CtorKind::Fn)`). Constructor `Foo` as `~const Fn` now trips the assert.
2. compiler/rustc_next_trait_solver/src/solve/effect_goals.rs, const-impl candidate: reservation polarity again hits `unimplemented!("reservation impl for const trait")` instead of ambiguous (coherence)/NoSolution. Re-expresses hunk `@@ -135,12 +135,16 @@` (`ty::ImplPolarity::Reservation => unimplemented!(...)`). The reservation-impl-ice test still passes (probably the impl is rejected earlier in 1.99.1), but the change is faithful.
