# Adapted injection for fix: Unexpected trait bound not satisfied in HRTB

Fix: https://github.com/rust-lang/rust/commit/d16444803836fa5fd665f9f5e303a9f4d113edd6

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/mod.rs, fn evaluate_trait_predicate_recursively.
Re-expresses fix hunk `@@ -1017,7 +1018,51 @@`: the fix replaced
`let (result, dep_node) = self.in_task(|this| this.evaluate_stack(&stack));` with a closure that, on
EvaluatedToErr for global predicates with aliases, normalizes the predicate and re-evaluates.
I removed that retry block (restoring the original one-liner), so HRTB bounds on assoc types are not normalized -> spurious error (#103563).
The import hunk (`@@ -27,6 +27,7 @@`) is not needed (may leave an unused import/variable warning).
