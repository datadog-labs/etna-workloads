# Adapted injection for review

Fix: https://github.com/rust-lang/rust/commit/2062f2ca8261b521caa9c34c195bf472dcb59e98

# Rationale
The fix.diff implementation part is only a rename (`self_ty_infer_ambiguity_hack` -> `assemble_self_ty_infer_ambiguity_response`)
plus test changes. The function was moved/rewritten in 1.99.1 (compiler/rustc_next_trait_solver/src/solve/assembly/mod.rs).
The behavioural bug (see the new test dont-normalize-proj-with-error.rs and the ambiguity test) concerns assembling
candidates for a goal whose self type is a projection/error/infer var: the goal must use the normalized self type.

Hunk: `assemble_and_evaluate_candidates` in compiler/rustc_next_trait_solver/src/solve/assembly/mod.rs.
Removed the `let goal = goal.with(.., with_replaced_self_ty(.., normalized_self_ty))` rebinding, so candidates are
assembled against the un-normalized self type. Re-expresses the area of fix hunks
`@@ -311,7 +311,7 @@ ... assemble_and_evaluate_candidates ... self_ty_infer_ambiguity_hack`
(the self-ty infer ambiguity handling before candidate assembly). This is an approximation: the fix is a rename,
so this is the closest faithful re-expression of the old self-type normalization/ambiguity behaviour.
Effect: dont-normalize-proj-with-error ICEs (panic at assembly/mod.rs "non-rigid self type").
