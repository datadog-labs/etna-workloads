# Adapted injection for Fix ICE for inherited const conditions on const closures

Fix: https://github.com/rust-lang/rust/commit/1ee6e9a1ffbb37a6e7af2b8697c67e69f200d4bb

# Rationale
File: compiler/rustc_trait_selection/src/traits/effects.rs, fn `evaluate_host_effect_for_fn_goal`, `ty::Closure` arm.
Re-expresses the fix hunk `@@ -530,15 +530,8 @@ fn evaluate_host_effect_for_fn_goal`: the fix replaced
building args from `[sig.inputs()[0], sig.output()]` with using the closure's own `args`. The bug re-introduces the
sig-derived args (instantiating const_conditions of the closure with wrong args, so inherited const conditions from the parent
`T: [const] Foo` are mis-instantiated -> ICE in the old solver). (In 1.99.1 the arm was `Binder::dummy(args)`; the buggy form wraps the sig-based args in Binder::dummy.)
