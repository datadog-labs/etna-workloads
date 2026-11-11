# Adapted injection for `single_use_lifetimes`: respect `anonymous_lifetime_in_impl_trait`

Fix: https://github.com/rust-lang/rust/commit/103923f25004b407beeeb70b387adc0956a3cb71

# Hunk: compiler/rustc_resolve/src/late.rs, `LateResolutionVisitor::visit_ty` (TyKind::ImplTrait arm)
Re-expresses fix hunk `@@ -943,7 +946,7 @@ ... TyKind::ImplTrait(..)`:
`-visit::walk_ty(self, ty);` / `+self.with_lifetime_rib(LifetimeRibKind::ImplTrait, |this| visit::walk_ty(this, ty));`
The buggy version no longer pushes an `ImplTrait` rib, so `single_use_lifetimes` ignores the `anonymous_lifetime_in_impl_trait` gate and suggests eliding lifetimes in `impl Trait` even when anonymous lifetimes aren't allowed there. The other (rib-handling) arms remain, now dead code but harmless.
