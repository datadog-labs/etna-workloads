# Adapted injection for Don't propagate synthetic params, remove lifetime hacks

Fix: https://github.com/rust-lang/rust/commit/c2383b53a26fe3f0108d20c94dd171c1faf4cfd2

# Hunk: compiler/rustc_ast_lowering/src/delegation/generics.rs, GenericArgsPropagator::next
Removed `|| p.is_impl_trait()` from the skip condition (line ~109), so synthetic (impl Trait) params are propagated as generic args again.
Re-expresses fix hunk `@@ -391,7 +390,7 @@` : `-if p.name.ident().name == kw::SelfUpper {` / `+if p.name.ident().name == kw::SelfUpper || p.is_impl_trait() {`.
(Other fix hunks, the lifetime hack removal in create_mapping, were not re-injected.)
