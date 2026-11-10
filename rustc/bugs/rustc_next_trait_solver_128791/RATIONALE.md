# Adapted injection for Don't implement AsyncFn for FnDef/FnPtr that wouldnt implement Fn

Fix: https://github.com/rust-lang/rust/commit/ec1c424293c04258da127ed4dfc8d4289834efe6

# Rationale
1. compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs, `assemble_async_closure_candidates`: restored unconditional `ty::FnDef(..) | ty::FnPtr(..) => push(AsyncClosureCandidate)`, removing the `is_fn_trait_compatible` and target_features checks. Re-expresses hunk `@@ -467,8 +467,20 @@` (old `ty::FnDef(..) | ty::FnPtr(..) => { candidates.vec.push(AsyncClosureCandidate); }`).
2. compiler/rustc_next_trait_solver/src/solve/assembly/structural_traits.rs, `extract_tupled_inputs_and_output_from_async_callable`: FnDef/FnPtr arms collapsed to `ty::FnDef(..) | ty::FnPtr(..) => fn_item_to_async_callable(cx, sig)` with no compatibility/target-feature checks (new solver). Re-expresses hunk `@@ -458,28 +458,23 @@` (the fix added the `is_fn_trait_compatible() && !has_target_features` guards). Helper function kept (hunk 2 only factored it out).
