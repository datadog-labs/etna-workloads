# Adapted injection for Don't worry about uncaptured contravariant lifetimes if they outlive a captured lifetime

Fix: https://github.com/rust-lang/rust/commit/f8f4d50aa34640906e0315adbf4c487712fab0cd

# Rationale
File: compiler/rustc_lint/src/impl_trait_overcaptures.rs, fn `VisitOpaqueTypes::visit_ty` (the `uncaptured_args.retain(...)` block).

Re-expresses fix hunk `@@ -218,25 +276,60 @@ ... impl TypeVisitor for VisitOpaqueTypes`, which added the
`covariant_long_args` filter ("Does this region outlive any captured region?" via
`outlives_env.free_region_map().sub_free_regions(..)`) and `uncaptured_args.retain(|arg| !covariant_long_args.contains(arg))`.
In 1.99.1 this is a `retain` whose final predicate is `!captured_regions.iter().any(.. sub_free_regions ..)`.
The bug (parent behaviour) is that uncontravariant lifetimes outliving a captured lifetime are still reported as uncaptured
(false-positive overcapture lint). I made the outlives check never remove args (predicate returns `true`), keeping the
variance/outlives computations referenced so no dead-code warnings appear.
