# Adapted injection for Use the trait object's own bounds instead of goal when considering builtin object bounds

Fix: https://github.com/rust-lang/rust/commit/ba3b486c3c0724223b226a0b4ee32977e9cb4ffb

# Re-injected bug
Fix hunks re-expressed (reverted) on 1.99.1:

1. compiler/rustc_next_trait_solver/src/solve/assembly/mod.rs, `probe_and_consider_object_bound_candidate`
   (fix hunk `@@ -88,10 +88,26 @@`): removed the `trait_ref` computed from the assumption clause
   (Trait/Projection) and pass `goal.predicate.trait_ref(cx)` again, i.e. the goal's trait ref
   instead of the object's own bound.
2. compiler/rustc_next_trait_solver/src/solve/assembly/structural_traits.rs, `predicates_for_object_candidate`
   (fix hunks `@@ -856,7 +856,7 @@` and `@@ -864,6 +864,7 @@`, plus the import hunk): parameter back to
   `trait_ref: ty::TraitRef<I>`, dropped `instantiate_binder_with_infer`, dropped the `Binder` import.

Not reverted: the coherence.rs hunk (principal_def_id, cosmetic) and the probe.rs
`enter_without_propagated_nested_goals` hunks (not needed for failure).
