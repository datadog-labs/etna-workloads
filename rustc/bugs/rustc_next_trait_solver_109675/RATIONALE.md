# Adapted injection for Do not consider elaborated projection predicates for objects in new solver

Fix: https://github.com/rust-lang/rust/commit/d62238d6a8ed57fecddfa9b97fd79cb0ac814791

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/assembly/mod.rs, fn `assemble_object_bound_candidates`
(1.99.1 location of the old `compiler/rustc_trait_selection/src/solve/assembly.rs` logic).

Fix hunk `@@ -489,9 +490,21 @@`: the fix elaborated the object's bounds but skipped elaborated projection
predicates not in the object's own bounds (`if assumption.to_opt_poly_projection_pred().is_some() && !own_bounds.contains(&assumption) { continue; }`).
Reinjected bug: after the principal-supertrait loop, I fully elaborate the principal trait ref and add object-bound
candidates for every projection clause not in the object's own bounds, i.e. the elaborated projections the fix removed.
This causes extra candidates/ambiguity (E0284 instead of E0271 in more-object-bound).
