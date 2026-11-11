# Adapted injection for Visit delegation's qself under elided-infer lifetime rib too

Fix: https://github.com/rust-lang/rust/commit/b75c53288e7784abdada2705c272f297e850cbd1

# Rationale
compiler/rustc_resolve/src/late.rs, `resolve_delegation`: fix hunk `@@ -3912,13 +3912,13 @@` moved
`if let Some(qself) = &delegation.qself { this.visit_ty(&qself.ty); }` inside the
`with_lifetime_rib(LifetimeRibKind::elided(LifetimeRes::Infer), ..)` closure. Reintroduced the bug by moving
the qself visit back before/outside the rib (`self.visit_ty(&qself.ty)`), so lifetimes in qself use the wrong rib (ICE).
