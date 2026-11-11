# Adapted injection for An async closure may implement FnMut/Fn if it has no self-borrows

Fix: https://github.com/rust-lang/rust/commit/2e97dae8d468623474d05dd84c270583ec3ed374

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs, `assemble_closure_candidates` (CoroutineClosure arm).
Re-expresses the fix hunk `@@ -418,20 +418,11 @@ impl<'cx, 'tcx> SelectionContext` which replaced
`if no_borrows && closure_kind.extends(kind)` (no_borrows = tupled upvars empty) with
`closure_kind.extends(kind) && !args.has_self_borrows()`. I restored the old `no_borrows` check, so async closures
with any (by-value) captures no longer implement Fn/FnMut.
The other fix hunks (sty.rs has_self_borrows, next-solver structural_traits) were left alone: the helper moved to rustc_type_ir and the new-solver path is not used by the old-solver oracle test.
