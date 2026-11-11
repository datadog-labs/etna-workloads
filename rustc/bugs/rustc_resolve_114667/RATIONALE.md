# Adapted injection for Record binder for bare trait object in LifetimeCollectVisitor

Fix: https://github.com/rust-lang/rust/commit/bbe7a96bec86eead5b6411856b92cfa012947195

# Rationale
File: compiler/rustc_resolve/src/late.rs, `LateResolutionVisitor::visit_ty`, `TyKind::Path` arm.

The fix's file (rustc_ast_lowering/src/lifetime_collector.rs, `LifetimeCollectVisitor::visit_ty`) no longer exists in 1.99.1.
The fix hunk `@@ -77,7 +77,20 @@ ... fn visit_ty` added `TyKind::Path(None, _)` handling: if the path resolves to
`DefKind::Trait | TraitAlias` (a bare trait object), `self.current_binders.push(t.id)` around `walk_ty`, so that
anonymous lifetimes in `Fn(&())` are bound by the bare trait object rather than captured by the enclosing `impl Trait`.
In 1.99.1 the equivalent binder is the `with_generic_param_rib(..., LifetimeBinderKind::PolyTrait, ...)` that late.rs
introduces for bare trait objects. I removed that special case (always plain `visit::walk_ty`), so bare trait objects
no longer record a binder (the old behaviour).
