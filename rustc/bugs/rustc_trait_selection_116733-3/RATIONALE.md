# Adapted injection for Consider alias bounds when considering lliveness for alias types in NLL

Fix: https://github.com/rust-lang/rust/commit/184d5ef1077869c58479d0c3fcab404b99090ed3

# Rationale
File: compiler/rustc_trait_selection/src/traits/outlives_for_liveness.rs, `FreeRegionsVisitor::visit_ty` (the 1.99.1 successor of the fix's `MakeAllRegionsLive::make_alias_live` in trace.rs).

The fix hunk `@@ -601,34 +604,88 @@ impl<'tcx> LivenessContext` replaced `tcx.for_each_free_region(&value, ..)` (all free regions of an alias are made live) with a visitor that, for `ty::Alias`, looks at the alias's item bounds `outlives_bounds` and visits only the outlives region (e.g. `'static`) when one exists.
Reintroduced old behaviour: the `ty::Alias(..)` arm is guarded by `if self.consider_alias_bounds()`, which returns false. Aliases fall through to `ty.super_visit_with(self)`, so all free regions in alias args are made live and the alias bounds are ignored. The fix's trace.rs import/visitor hunks have no 1.99.1 equivalent beyond this.
