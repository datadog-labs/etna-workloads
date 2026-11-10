# Adapted injection for Don't create projection ty for const projection

Fix: https://github.com/rust-lang/rust/commit/cde5bcafe89658a43b7cf865f58057db29f4d531

# Rationale
File: compiler/rustc_trait_selection/src/traits/project.rs, fn `project`, arm `ProjectionCandidateSet::None`.
Fix hunk `@@ -1272,14 +1272,29 @@ fn project`: the fix replaced an unconditional `mk_projection(def_id, substs).into()` (a projection *type* even for assoc consts) by a match on def kind, building a const for `AssocConst`.
1.99.1 already uses `predicate.to_term(...)`, which dispatches on kind. I re-injected the bug: for `AliasTermKind::ProjectionConst` the NoProgress term is built as a projection `Ty` alias with the const's def_id and args; other kinds still use `to_term`.
