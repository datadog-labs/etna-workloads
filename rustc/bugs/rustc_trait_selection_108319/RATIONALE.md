# Adapted injection for Don't project specializable RPITIT projection

Fix: https://github.com/rust-lang/rust/commit/9bf32c40b4c1b7558aee3421ed3e8e73ef518dd9

# Rationale
File: compiler/rustc_trait_selection/src/traits/project.rs, `assemble_candidates_from_impls` (UserDefined arm).
The fix's hunk `@@ -1307,21 +1307,38 @@ fn assemble_candidate_for_impl_trait_in_trait` added the `leaf_def.is_final() || (Reveal::All && !still_further_specializable())` check before pushing the RPITIT candidate (previously it always pushed it). In 1.99.1 RPITIT goes through the normal assoc-type path, so I re-expressed the bug by making the specializable-default check be skipped for RPITIT projections: `node_item.is_final() || tcx.is_impl_trait_in_trait(projection_def_id)` => always projectable, even for `default` items.
