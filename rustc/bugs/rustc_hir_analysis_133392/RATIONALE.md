# Adapted injection for Fix ICE when multiple supertrait substitutions need assoc but only one is provided

Fix: https://github.com/rust-lang/rust/commit/43e2fd5086debfa74f33f6c323d21a756abb8236

# Rationale
One hunk, compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, in lower_trait_object_ty (final `filter_map` over `ordered_associated_items`).
Re-expresses the fix's dyn_compatibility.rs hunks `@@ -145,16 +145,18 @@` / `@@ -206,7 +208,10 @@`, which changed `needed_associated_types` from keyed by `def_id` to keyed by `(def_id, trait_ref)`. In 1.99.1 that code moved to dyn_trait.rs. The bug is that an assoc item counts as provided when any projection with the same def_id exists, ignoring the supertrait substitution. So `Sup<u32>::Assoc` is considered specified because `Sup<A, Assoc=A>` is. The added check is `projection_bounds.keys().any(|(d,_)| *d == def_id)`.
