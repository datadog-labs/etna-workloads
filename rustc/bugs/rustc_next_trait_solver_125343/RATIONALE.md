# Adapted injection for eagerly normalize when adding goals

Fix: https://github.com/rust-lang/rust/commit/98bfd54b0abd938d6b424d45b57766e6f2f41ea2

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/eval_ctxt/mod.rs, `EvalCtxt::add_goal`.

Fix hunk re-expressed: `@@ -455,13 +458,23 @@ ... add_goal` in the old rustc_trait_selection eval_ctxt/mod.rs, which added
`goal.predicate = goal.predicate.fold_with(&mut ReplaceAliasWithInfer {..})`, i.e. eagerly normalizing
the aliases in a goal when it is added. In 1.99.1 that logic lives in `add_goal` as
`goal.predicate = self.normalize(GoalSource::NormalizeGoal(..), param_env, ..)?`. I removed that call, so
goals are added without eager normalization (the pre-fix behaviour). `goal` no longer needs to be `mut`.
The other fix hunks (allow_normalization in predicate.rs, ReplaceAliasWithInfer struct) have no
direct equivalent in 1.99.1 and were not changed.
