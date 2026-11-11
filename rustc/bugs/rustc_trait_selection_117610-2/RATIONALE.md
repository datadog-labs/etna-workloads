# Adapted injection for Only check predicates for late-bound non-lifetime vars in object candidate assembly

Fix: https://github.com/rust-lang/rust/commit/24e14dd8b40a2434fc2343342c30d8d5748d1c5a

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs, `assemble_candidates_from_object_ty`.
Fix hunk `@@ -628,7 +628,10 @@`: changed `if obligation.has_non_region_late_bound()` to `if obligation.self_ty().has_non_region_late_bound()`.
In 1.99.1 that check no longer exists at all (the code uses enter_forall), so I re-added the buggy form at the start of the probe: bail out if the whole obligation (predicate + param_env) has non-region bound vars (`has_non_region_bound_vars`, the renamed method; `Obligation` itself doesn't expose it so I check predicate and param_env). This disqualifies object candidates because of bound vars in the param env, not just the self type.
