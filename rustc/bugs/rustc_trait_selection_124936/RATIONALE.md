# Adapted injection for analyse visitor: build proof tree in probe

Fix: https://github.com/rust-lang/rust/commit/83e6da0be5e0e7cec8326ad5c4ba463299d32eea

# Rationale
File: compiler/rustc_trait_selection/src/solve/inspect/analyse.rs, fn `instantiate_proof_tree_for_nested_goal`.
Removed the `infcx.probe(|_| ...)` around `evaluate_root_goal_for_proof_tree(goal, span)`, so evaluating the nested goal leaks inference constraints.
Re-expresses fix hunk `@@ -225,13 +243,17 @@` (the `_ =>` arm): the fix replaced `infcx.evaluate_root_goal(goal, GenerateProofTree::Yes).1.unwrap()` with `infcx.probe(|_| infcx.evaluate_root_goal(...).1).unwrap()` ("We're using a probe here as evaluating a goal could constrain inference variables"). On 1.99.1 the NormalizesTo arm is unreachable, so only this arm exists. The #instrument hunks are not behavioural.
