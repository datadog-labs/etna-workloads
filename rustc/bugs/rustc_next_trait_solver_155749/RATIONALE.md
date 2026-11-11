# Adapted injection for `-Znext-solver` Ignore region constraints from the nested goals in leakcheck

Fix: https://github.com/rust-lang/rust/commit/e43a1b5b449e5f629efd7242c081e98a1ca02d33

# Rationale
One hunk: compiler/rustc_next_trait_solver/src/canonical/mod.rs, `instantiate_and_apply_query_response`.
In 1.99.1 the fix's per-goal `vis` parameter has become a hard-coded `vis.and(VisibleForLeakCheck::No)` for region constraints from nested goals (with the FIXME comment from the fix's eval_ctxt hunk `@@ -484,11 +485,29 @@` "We ignore constraints from the nested goals in leak check"). I changed it to `vis.and(VisibleForLeakCheck::Yes)`, so nested-goal region constraints are visible to the leak check again (the pre-fix behaviour: `register_region_constraints(delegate, region_constraints, span)` with everything visible).
